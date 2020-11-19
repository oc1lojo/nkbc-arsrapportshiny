library(dplyr)
library(tidyr)
library(nkbcind)

nkbcind_nams <- c(
  # Täckningsgrad
  "nkbc33", # Täckningsgrad mot cancerregistret
  "nkbc36", # Täckningsgrad för rapportering av operation
  "nkbc13", # Täckningsgrad för rapportering av preoperativ onkologisk behandling
  "nkbc14", # Täckningsgrad för rapportering av postoperativ onkologisk behandling

  # Population
  "nkbc09a", # Kön
  "nkbc09b", # Ålder
  "nkbc09c", # Invasivitet
  "nkbc09d", # Biologisk subtyp
  "nkbc09i", # Tumörstorlek (klinisk) vid diagnos
  "nkbc09h", # Tumörstorlek vid operation
  "nkbc09e", # Spridning till lymfkörtlarna vid diagnos
  "nkbc09g", # Spridning till lymfkörtlarna vid operation
  "nkbc09f", # Fjärrmetastaser vid diagnos

  # Ledtider
  "nkbc17", # Välgrundad misstanke om cancer till första besök i specialiserad vård
  "nkbc15", # Välgrundad misstanke om cancer till operation
  "nkbc16", # Välgrundad misstanke om cancer till preoperativ onkologisk behandling
  "nkbc48", # Provtagningsdatum till operation
  "nkbc49", # Provtagningsdatum till preoperativ onkologisk behandling
  "nkbc22", # Operation till cytostatikabehandling
  "nkbc23", # Operation till strålbehandling

  # Diagnostik
  "nkbc01", # Screeningupptäckt bröstcancer
  "nkbc06", # Fastställd diagnos innan operation
  "nkbc04", # Multidisciplinär konferens inför behandlingstart
  "nkbc05", # Multidisciplinär konferens efter operation
  "nkbc10", # Fullständig patologirapport

  # Omvårdnad
  "nkbc02", # Kontaktsjuksköterska
  "nkbc03", # Min vårdplan

  # Primär behandling
  "nkbc47", # Preoperativ onkologisk behandling

  # Kirurgi
  "nkbc42", # Bröstbevarande operation
  "nkbc53", # Bröstbevarande operation vid små invasiva tumörer
  "nkbc54", # Bröstbevarande operation vid små icke-invasiva tumörer
  "nkbc07", # Omedelbara rekonstruktioner vid mastektomi
  "nkbc08", # Enbart en operation
  "nkbc45", # Axillkirurgi
  "nkbc26", # Sentinel node operation

  # Onkologisk behandling
  "nkbc35", # Cytostatikabehandling, pre- respektive postoperativt
  "nkbc46", # Cytostatikabehandling, måluppfyllelse
  "nkbc28", # Strålbehandling efter bröstbevarande operation
  "nkbc29", # Strålbehandling efter mastektomi
  "nkbc41", # Endokrin behandling, pre- respektive postoperativt
  "nkbc31", # Endokrin behandling, måluppfyllelse
  "nkbc32", # Antikroppsbehandling bland cytostatikabehandlade

  # Överlevnad
  "nkbc30" # Observerad 5-årsöverlevnad
)

df_rsconnect_apps <-
  rsconnect::applications() %>%
  filter(!grepl("dashboard$", name)) %>%
  tidyr::separate(
    col = "name",
    into = c("register", "lang", "appnamn"),
    sep = "_"
  ) %>%
  mutate(
    kortnamn = paste0("nkbc_", gsub("-", "_", appnamn))
  )

for (sel_lang in c("sv", "en")) {
  for (i in seq(along = nkbcind_nams)) {
    nkbcind <- get(nkbcind_nams[i])

    id <- df_rsconnect_apps %>%
      filter(
        lang == sel_lang,
        kortnamn == kortnamn(nkbcind)
      ) %>%
      select(id) %>%
      unlist()

    cat(
      paste0(
        "<li class='reportLi'>",
        "<a data-toggle='pill' href='#reportDiv' class='reportLink' id='",
        id,
        "'>",
        lab_short(nkbcind)[[sel_lang]],
        "</a>",
        "</li>",
        "\n"
      )
    )
  }
}
