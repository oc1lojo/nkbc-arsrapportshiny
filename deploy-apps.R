# Anpassat utifrån
# https://statistik.incanet.se/guide/rccShiny---RStudio-Connect.html#uppdatera-redan-publicerad-applikation

library(dplyr)
library(keyring)
library(rsconnect)
library(connectapi)

# Prefix för register ----------------------------------------------------------
globalRegisterPrefix <- "brostcancer"

# API --------------------------------------------------------------------------
connectServer <- "https://statistik.incanet.se"
connectAPIKey <- keyring::key_get("r-statistik.incanet.se-brostcancer-api", "jolo01")

client <- connectapi::connect(
  host = connectServer,
  api_key = connectAPIKey
)

# Hämta lista på alla applikationer på servern och välj ut de där namnet innehåller prefix
# (Observera att ens användare måste ha skrivrättigheter till de applikationer man önskas justera)
tempListApplications <-
  connectapi::get_content(client, limit = Inf, page_size = 999999) %>%
  dplyr::filter(stringr::str_detect(name, globalRegisterPrefix))

# Publicera (om) appar ---------------------------------------------------------

tempListApps <- c(
  list.dirs(path = "apps/sv", recursive = FALSE),
  list.dirs(path = "apps/en", recursive = FALSE)
)

for (i in 1:length(tempListApps)) {
  cat(paste0("Publicerar (", i, "/", length(tempListApps), "): ", tempListApps[i], "...\n"))

  # Namngivningskonvention: register_språk_app
  tempAppName <- paste(
    c(globalRegisterPrefix, unlist(strsplit(tempListApps[i], split = .Platform$file.sep))[2:3]),
    collapse = "_"
  )

  # Kontrollera om en app med samma namn finns på servern redan, uppdatera den i sådana fall
  tempDfAppId <- tempListApplications %>%
    dplyr::filter(name %in% tempAppName) %>%
    dplyr::arrange(id) %>%
    dplyr::distinct(id)
  if (nrow(tempDfAppId) > 0) {
    tempAppId <- tempDfAppId$id
  } else {
    tempAppId <- NULL
  }

  suppressMessages(
    suppressWarnings(
      rsconnect::deployApp(
        appDir = tempListApps[i],
        appName = tempAppName,
        appId = tempAppId,
        logLevel = "quiet",
        forceUpdate = TRUE
      )
    )
  )
}


# Menysida --------------------------------------------------------------------

setwd("menysida")

tempAppFiles <- c("index.html", list.files("_libs", full.names = TRUE, recursive = TRUE))

# Inspektera filer
tempAppFiles

# Kontrollera om ett dokument med samma namn finns på servern redan, uppdatera det i sådana fall
tempDfAppId <- tempListApplications %>%
  dplyr::filter(name %in% globalRegisterPrefix) %>%
  dplyr::arrange(id) %>%
  dplyr::distinct(id)
if (nrow(tempDfAppId) > 0) {
  tempAppId <- tempDfAppId$id
} else {
  tempAppId <- NULL
}

rsconnect::deployApp(
  appDir = ".",
  appFiles = tempAppFiles,
  appName = globalRegisterPrefix,
  appId = tempAppId,
  appPrimaryDoc = "index.html",
  logLevel = "quiet",
  forceUpdate = TRUE
)

setwd("..")
