# Anpassat utifrån
# https://prestatistik.incanet.se/guide/rccShiny---RStudio-Connect.html#uppdatera-redan-publicerad-applikation

library(dplyr)
library(keyring)
library(connectapi)

# Serveradress (justeras till produktionsservern om så behövs) och API Key
connectServer <- "https://prestatistik.incanet.se"
connectAPIKey <- keyring::key_get("r-statistik.incanet.se-brostcancer-api", "jolo01")

# Definiera uppkoppling för att använda i funktionerna i paketet connectapi
client <- connectapi::connect(
  host = connectServer,
  api_key = connectAPIKey
)

# Hämta lista på alla applikationer på servern och välj ut de där namnet innehåller
# "brostcancer_sv_" eller "brostcancer_en_"
# (Observera att ens användare måste ha skrivrättigheter till de applikationer man önskas justera)
tempListApplications <- connectapi::get_content(client, limit = Inf, page_size = 999999) %>%
  dplyr::filter(
    stringr::str_detect(name, "brostcancer_sv_") |
    stringr::str_detect(name, "brostcancer_en_")
  )

# Hämta lista på användare och grupper på servern
tempUsers <- connectapi::get_users(client)
tempGroups <- connectapi::get_groups(client)

# Definiera vilka användarnamn respektive gruppnamn som ska ges skrivrättigheter till applikationerna
tempListAddCollaboratorUsers <- c("soho01")
# tempListAddCollaboratorGroups <- c("grp.usr.stat.testGroup1")

# Loopa igenom alla applikationer i urvalet
for (i in 1:nrow(tempListApplications)) {
  # Sätt Sharing settings till "all"
  resp <-
    httr::POST(
      paste0(connectServer, "/__api__/v1/experimental/content/", tempListApplications$guid[i]),
      httr::add_headers(Authorization = paste("Key", connectAPIKey)),
      body = list(access_type = "all"),
      encode = "json"
    )

  # Skapa ett objekt av typ connectapi::Content för applikation
  tempContent <-
    connectapi::content_item(
      connect = client,
      guid = tempListApplications$guid[i]
    )

  # Lägg till användare
  for (j in tempListAddCollaboratorUsers) {
    if (j %in% tempUsers$username) {
      connectapi::acl_add_user(
        content = tempContent,
        user_guid = tempUsers$guid[tempUsers$username %in% j],
        role = "owner"
      )
    }
  }
  # # Lägg till grupper
  # for (j in tempListAddCollaboratorGroups) {
  #   if (j %in% tempGroups$name) {
  #     connectapi::acl_add_group(
  #       content = tempContent,
  #       group_guid = tempGroups$guid[tempGroups$name %in% j],
  #       role = "owner"
  #     )
  #   }
  # }

  # Sätt Content URL
  connectapi::set_vanity_url(
    content = tempContent,
    url = paste0("/", tempListApplications$name[i])
  )

  # Skriv ut meddelande
  print(paste(tempListApplications$name[i], "...", ifelse(resp$status_code %in% 200, "SUCCESS", "FAILED")))
}
