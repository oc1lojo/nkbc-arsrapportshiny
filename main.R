# Läs in R-paket och verktygsfunktioner ----------------------------------------
library(dplyr)
library(tidyr)
library(lubridate)
library(readr)
library(shiny)
library(rccShiny)

# install.packages("devtools")
# devtools::install_bitbucket("cancercentrum/nkbcgeneral") # inte implementerad än
# devtools::install_bitbucket("cancercentrum/nkbcind") # inte implementerad än

# library(nkbcgeneral) # inte implementerat än
for (file_name in list.files("nkbcgeneral", pattern = "*.R$")) {
  source(file.path("nkbcgeneral", file_name), encoding = "UTF-8")
}

# library(nkbcind) # inte implementerat än
for (file_name in list.files("nkbcind", pattern = "*.R$")) {
  source(file.path("nkbcind", file_name), encoding = "UTF-8")
}

# Temporär work-around för att hantera NULL. TODO Bättre lösning
one_of <- function(x, ...) if (!is.null(x)) dplyr::one_of(x, ...)

# Definera globala variabler ---------------------------------------------------
report_end_year <- 2018

# Läs in data ------------------------------------------------------------------

# Läs in namn på sjukhus (hämta från organisationsenhetsregistret i framtiden)
load("G:/Hsf/RCC-Statistiker/_Generellt/INCA/Data/sjukhusKlinikKoder/sjukhuskoder.RData")

# Läs in ögonblickskopia av NKBC exporterad från INCA
load(
  unzip(
    file.path(Sys.getenv("BRCA_DATA_DIR"), "2019-09-02", "nkbc_nat_id 2019-09-02 09-02-35.zip"),
    exdir = tempdir()
  )
)

# # Läs in data för täckningsgrad mot cancerregistret
# df_list <- list() # initialisera
# for (i in 1:6) {
#   df_list[[i]] <-
#     read_delim(
#       file.path(
#         "G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Utdata/Arsrapport/2018.2/Täckningsgrader",
#         paste0("nkbc_tg_oc", i, ".txt")
#       ),
#       delim = " ",
#       col_types = cols(
#         period = col_integer(),
#         finns = col_integer(),
#         finns_proc = col_double(),
#         saknas = col_integer(),
#         totalt = col_integer()
#       )
#     ) %>%
#     mutate(region = i) %>%
#     select(region, period, finns, saknas)
# }
# df_tg <- purrr::map_dfr(df_list, bind_rows) %>%
#   filter(
#     # Standardinklusion av tidsperioder för de interaktiva rapporterna
#     period >= 2009,
#     period <= report_end_year
#   )

# Bearbeta data ----------------------------------------------------------------

# Bearbeta dataram med sjukhuskoder
sjukhuskoder <- sjukhuskoder %>%
  rename(
    sjukhus = sjukhusnamn,
    region_sjh_txt = region
  ) %>%
  mutate(
    sjukhus = if_else(
      sjukhus %in% c("Enhet utan INCA-rapp", "VC/Tjänsteläkare"), NA_character_, sjukhus
    ),
    # Samredovisning av landsting SKAS
    sjukhus = if_else(
      sjukhus %in% c("Skövde", "Lidköping"), "Skaraborg", sjukhus
    )
  )

# Bearbeta huvud-dataram
df_main <- df %>%
  mutate_if(is.factor, as.character) %>%
  clean_nkbc_data() %>%
  mutate_nkbc_d_vars() %>%
  mutate_nkbc_other_vars() %>%
  mutate(
    # Beräkna variabel för tidsperioder
    period = year(a_diag_dat)
  ) %>%
  filter(
    # Standardinklusion av tidsperioder för de interaktiva rapporterna
    period >= 2009,
    period <= report_end_year
  )

# Skapa webbapplikationer ------------------------------------------------------

nkbcind_nams <- c(
  # Täckningsgrad
  # "nkbc33", # tackning_mot_cancerreg
  "nkbc13", # tackning_for_preop_beh
  "nkbc14", # tackning_for_postop_beh

  # Population
  "nkbc09a", # pop_kon
  "nkbc09b", # pop_alder
  "nkbc09c", # pop_invasiv
  "nkbc09d", # pop_subtyp
  "nkbc09i", # pop_tnm_t
  "nkbc09h", # pop_t
  "nkbc09e", # pop_tnm_n
  "nkbc09g", # pop_n
  "nkbc09f", # pop_tnm_m

  # Ledtider
  "nkbc43", # ledtid_misstanke_till_prim_beh
  "nkbc15", # ledtid_misstanke_till_op
  "nkbc16", # ledtid_misstanke_till_preop_beh
  "nkbc17", # ledtid_misstanke_till_besok_spec
  "nkbc44", # ledtid_provtagn_till_prim_beh
  "nkbc19", # ledtid_behdisk_till_op
  "nkbc20", # ledtid_behdisk_till_preop_beh
  "nkbc22", # ledtid_op_till_cytostatikabeh
  "nkbc23", # ledtid_op_till_stralbeh

  # Diagnostik
  "nkbc01", # diag_screening
  "nkbc04", # diag_mdk_innan_beh
  "nkbc05", # diag_mdk_efter_op
  "nkbc06", # diag_klar_innan_op
  "nkbc10", # diag_komplett_patologi

  # Omvårdnad
  "nkbc02", # omv_kontaktssk
  "nkbc03", # omv_vardplan

  # Primär behandling
  "nkbc40", # kir_prim_beh

  # Kirurgi
  "nkbc42", # kir_brostbev_op
  "nkbc11", # kir_brostbev_op_sma_tum
  "nkbc07", # kir_direktrek
  "nkbc08", # kir_omop
  "nkbc45", # kir_axillkir
  "nkbc26", # kir_sentinel_node

  # Onkologisk behandling
  "nkbc35", # onk_cytostatikabeh
  "nkbc27", # onk_postop_cytostatikabeh_bland_erneg
  "nkbc28", # onk_stralbeh_efter_brostbev_op
  "nkbc29", # onk_stralbeh_efter_mastektomi
  "nkbc31", # onk_endokrin_beh_maluppfyllelse
  "nkbc41", # onk_endokrin_beh_fordelning
  "nkbc32", # onk_antikroppbeh_bland_cytostatikabeh_her2pos

  # Studier
  "nkbc39", # pat_i_studie

  # Överlevnad
  "nkbc30" # overlevnad_5ar
)

for (i in seq(along = nkbcind_nams)) {
  nkbcind_nam <- nkbcind_nams[i]
  nkbcind <- get(nkbcind_nam)

  # Förbearbeta data
  if (!(nkbcind_nam %in% c("nkbc30", "nkbc33"))) {
    df_tmp <- df_main %>%
      add_sjhdata(sjukhuskoder, sjhkod_var(nkbcind)) %>%
      filter(!is.na(region)) %>%
      nkbcind$filter_pop() %>%
      nkbcind$mutate_outcome() %>%
      select(
        landsting, region, sjukhus, period, outcome,
        one_of(other_vars(nkbcind))
      )
  } else if (nkbcind_nam == "nkbc30") {
    # Data för indikator nkbc30
    df_tmp <- df_main %>%
      add_sjhdata(sjukhuskoder, sjhkod_var(nkbcind)) %>%
      filter(!is.na(region)) %>%
      nkbcind$filter_pop() %>%
      nkbcind$mutate_outcome() %>%
      select(
        outcome, period, region, landsting, # OBS Ej sjukhus
        one_of(other_vars(nkbcind))
      )
  } else if (nkbcind_nam == "nkbc33") {
    # Data för indikator nkbc33
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
  }

  if (!is.null(nkbcind$inkl_beskr_onk_beh) && nkbcind$inkl_beskr_onk_beh |
    nkbcind_nam %in% c("nkbc16", "nkbc20") # TODO skall inte dessa också ha kommentar i beskrivning?
  ) {
    df_tmp <- df_tmp %>%
      # Ett år bakåt då info från onk behandling blanketter
      filter(period <= report_end_year - 1)
  } else if (nkbcind_nam == "nkbc30") {
    df_tmp <- df_tmp %>%
      # 5 års överlevnad så krävs 5 års uppföljning
      filter(period <= report_end_year - 5)
  }

  # Skapa webbapplikation
  rccShiny(
    data = as.data.frame(df_tmp),
    folder = code(nkbcind),
    outcomeTitle = lab(nkbcind),
    textBeforeSubtitle = textBeforeSubtitle(nkbcind),
    description = description(nkbcind, report_end_year),
    varOther = varOther(nkbcind),
    propWithinUnit = ifelse(!is.null(prop_within_unit(nkbcind)), prop_within_unit(nkbcind), "dagar"), # work-around, använd standardvärde
    propWithinValue = ifelse(!is.null(prop_within_value(nkbcind)), prop_within_value(nkbcind), 30), # work-around, använd standardvärde
    targetValues = target_values(nkbcind)
  )
}
