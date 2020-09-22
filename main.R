# Läs in R-paket och verktygsfunktioner ----------------------------------------
library(dplyr)
library(tidyr)
library(forcats)
library(lubridate)
library(readr)
library(shiny)
library(rccShiny)
library(nkbcgeneral) # https://cancercentrum.bitbucket.io/nkbcgeneral/
library(nkbcind) # https://cancercentrum.bitbucket.io/nkbcind/

# Temporär work-around för att hantera NULL. TODO Bättre lösning
one_of <- function(x, ...) if (!is.null(x)) dplyr::one_of(x, ...)

# Definera globala variabler ---------------------------------------------------
report_end_year <- 2019

# Läs in data ------------------------------------------------------------------

# Läs in namn på sjukhus (hämta från organisationsenhetsregistret i framtiden)
load("G:/Hsf/RCC-Statistiker/_Generellt/INCA/Data/sjukhusKlinikKoder/sjukhuskoder.RData")

# Läs in ögonblickskopia av NKBC exporterad från INCA
load(
  file.path(Sys.getenv("BRCA_DATA_DIR"), "2020-09-01", "nkbc_nat_avid 2020-09-01 07-49-29.RData")
)

# Bearbeta data ----------------------------------------------------------------

# Bearbeta dataram med sjukhuskoder
sjukhuskoder <- sjukhuskoder %>%
  dplyr::rename(
    sjukhus = sjukhusnamn,
    region_sjh_txt = region
  ) %>%
  mutate(
    sjukhuskod = as.integer(sjukhuskod),
    sjukhus = if_else(
      sjukhus %in% c("Enhet utan INCA-rapp", "VC/Tjänsteläkare"), NA_character_, sjukhus
    )
  )

# Bearbeta huvud-dataram
df_main <- df %>%
  mutate_if(is.factor, as.character) %>%
  # rename_all(iconv, from = "UTF-8") %>%
  # mutate_if(is.character, iconv, from = "UTF-8") %>%
  rename_all(stringr::str_replace, "_Värde", "_Varde") %>%
  clean_nkbc_data() %>%
  mutate_nkbc_d_vars() %>%
  mutate_nkbcind_d_vars() %>%
  mutate(
    # Beräkna variabel för tidsperioder
    period = year(a_diag_dat)
  ) %>%
  filter(
    # Standardinklusion av tidsperioder för de interaktiva rapporterna
    period >= 2008,
    period <= report_end_year
  )

# Skapa webbapplikationer ------------------------------------------------------

nkbcind_nams <- c(
  # Täckningsgrad
  # "nkbc33", # Täckningsgrad mot cancerregistret - Specialfall, se nedan
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
  "nkbc04", # Multidisciplinär konferens inför behandlingstart
  "nkbc05", # Multidisciplinär konferens efter operation
  "nkbc06", # Fastställd diagnos innan operation
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
  "nkbc31", # Endokrin behandling, måluppfyllelse
  "nkbc41", # Endokrin behandling, pre- respektive postoperativt
  "nkbc32", # Antikroppsbehandling bland cytostatikabehandlade

  # Överlevnad
  "nkbc30" # Observerad 5-årsöverlevnad
)

for (i in seq(along = nkbcind_nams)) {
  nkbcind_nam <- nkbcind_nams[i]
  nkbcind <- get(nkbcind_nam)

  # Förbearbeta data
  df_tmp <- df_main %>%
    add_sjhdata(sjukhuskoder, sjhkod_var(nkbcind)) %>%
    filter(!is.na(region)) %>%
    filter_pop(nkbcind)() %>%
    mutate_outcome(nkbcind)() %>%
    select(
      one_of(geo_units_vars(nkbcind)),
      period,
      one_of(
        outcome(nkbcind),
        paste0(outcome(nkbcind), "_en")
      ),
      one_of(
        other_vars(nkbcind),
        paste0(other_vars(nkbcind), "_en")
      )
    )

  if (!is.null(nkbcind$inkl_beskr_onk_beh) && nkbcind$inkl_beskr_onk_beh) {
    df_tmp <- df_tmp %>%
      # Ett år bakåt då info från onk behandling blanketter
      filter(period <= report_end_year - 1)
  } else if (nkbcind_nam == "nkbc30") {
    df_tmp <- df_tmp %>%
      # 5-årsöverlevnad så krävs 5 års uppföljning
      filter(period <= report_end_year - 5)
  }

  # Skapa webbapplikation
  if (!is.null(prop_within_unit(nkbcind))) {
    propWithinUnit <- prop_within_unit(nkbcind)
  } else {
    # work-around, använd standardvärde
    propWithinUnit <- c(sv = "dagar", en = "days")
  }

  rccShiny2(
    language = c("sv", "en"),
    data = as.data.frame(df_tmp),
    folder = gsub("_", "-", sub("^nkbc_", "", kortnamn(nkbcind))),
    outcome = outcome(nkbcind),
    outcomeTitle = outcomeTitle(nkbcind, locale = c("sv", "en")),
    periodLabel = c(
      sv = "Diagnosår",
      en = "Diagnosis year"
    ),
    textBeforeSubtitle = textBeforeSubtitle(nkbcind, locale = c("sv", "en")),
    description = description(nkbcind, report_end_year, locale = c("sv", "en")),
    varOther = varOther(nkbcind, locale = c("sv", "en")),
    propWithinUnit = propWithinUnit,
    propWithinValue = ifelse(!is.null(prop_within_value(nkbcind)), prop_within_value(nkbcind), 30), # work-around, använd standardvärde
    targetValues = target_values(nkbcind),
    sort = !all(geo_units_vars(nkbcind) %in% "region"),
    gaPath = "/brostcancer/_libs/ga.js"
  )
}

# Specialfall nkbc33 - Täckningsgrad mot cancerregistret -----------------------

# Läs in data för täckningsgrad mot cancerregistret
df_list <- lapply(
  seq(from = 1, to = 6),
  function(x) {
    read_delim(
      file.path(
        "G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Utdata/Arsrapport/2019.2/Täckningsgrader",
        paste0("nkbc_tg_rcc", x, ".txt")
      ),
      delim = " ",
      col_types = cols(
        period = col_integer(),
        finns = col_integer(),
        finns_proc = col_double(),
        saknas = col_integer(),
        totalt = col_integer()
      )
    ) %>%
      mutate(region = x) %>%
      select(region, period, finns, saknas)
  }
)
df_tg <- purrr::map_dfr(df_list, bind_rows) %>%
  filter(
    # Standardinklusion av tidsperioder för de interaktiva rapporterna
    period >= 2009,
    period <= report_end_year
  )

# Förbearbeta data för täckningsgrad mot cancerregistret
df_tmp <- data.frame(
  region = c(
    rep(df_tg$region, df_tg$finns),
    rep(df_tg$region, df_tg$saknas)
  ),
  period = c(
    rep(df_tg$period, df_tg$finns),
    rep(df_tg$period, df_tg$saknas)
  ),
  outcome = c(
    rep(rep(TRUE, dim(df_tg)[1]), df_tg$finns),
    rep(rep(FALSE, dim(df_tg)[1]), df_tg$saknas)
  )
)

# Skapa webbapplikation för nkbc33
rccShiny2(
  language = c("sv", "en"),
  data = as.data.frame(df_tmp),
  folder = gsub("_", "-", sub("^nkbc_", "", kortnamn(nkbc33))),
  outcome = outcome(nkbc33),
  outcomeTitle = outcomeTitle(nkbc33, locale = c("sv", "en")),
  periodLabel = c(
    sv = "Diagnosår",
    en = "Diagnosis year"
  ),
  textBeforeSubtitle = textBeforeSubtitle(nkbc33, locale = c("sv", "en")),
  description = description(nkbc33, report_end_year, locale = c("sv", "en")),
  varOther = varOther(nkbc33, locale = c("sv", "en")),
  targetValues = target_values(nkbc33),
  sort = FALSE,
  gaPath = "/brostcancer/_libs/ga.js"
)
