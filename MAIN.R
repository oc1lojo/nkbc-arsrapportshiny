# Läs in R-paket ------------------------------------------------------------------

library(dplyr)
library(lubridate)
library(shiny)
library(rccShiny)

# Läs in/Definera "konstanter" och verktygsfunktioner -----------------------------

YEAR <- 2017
OUTPUTPATH <- "Output"

source("nkbc-general.R", encoding = "utf8")
source("beskTXT.R", encoding = "utf8")

# Läs in data ------------------------------------------------------------------

# Läs in ögonblickskopia av NKBC exporterad från INCA
nkbc_data_dir <- Sys.getenv("NKBC_DATA_DIR")
load(
  unzip(
    file.path(nkbc_data_dir, "2018-08-31", "nkbc_nat_id 2018-08-31 09-22-09.zip"),
    exdir = tempdir()
  )
)

# Läs in namn på sjukhus (hämta från organisationsenhetsregistret i framtiden)
load("G:/Hsf/RCC-Statistiker/_Generellt/INCA/Data/sjukhusKlinikKoder/sjukhuskoder.RData")

# Läs in data för täckningsgrad mot cancerregistret
tackning_tbl <- readxl::read_excel("G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Utdata/Arsrapport/2017.2/Täckningsgrader/Tackningsrader_alla_regioner.xlsx")

# Bearbeta data ----------------------------------------------------------------

# Bearbeta huvud-dataram
dfmain <- df %>%
  mutate_if(is.factor, as.character) %>%
  derive_nkbc_d_vars() %>%
  mutate(
    period = year(a_diag_dat), # Den period som appar visas för
    opyear = year(op_kir_dat),
    # landsting_lkf = as.numeric(substr(a_pat_lkfdia, 1, 2)),
    # landsting_lkf = ifelse(landsting_lkf %in% c(1, seq(3, 10), seq(12, 14), seq(17, 25)),
    #   landsting_lkf,
    #   NA
    # ),

    # lkf region för att imputera om region för sjukhus saknas
    region_lkf = case_when(
      REGION_NAMN == "Region Sthlm/Gotland" ~ 1L,
      REGION_NAMN == "Region Uppsala/Örebro" ~ 2L,
      REGION_NAMN == "Region Sydöstra" ~ 3L,
      REGION_NAMN == "Region Syd" ~ 4L,
      REGION_NAMN == "Region Väst" ~ 5L,
      REGION_NAMN == "Region Norr" ~ 6L,
      TRUE ~ NA_integer_
    )
  ) %>%
  filter( # default vilka år som ska visas
    period >= 2009,
    period <= YEAR
  )

# Bearbeta dataram med sjukhuskoder
sjukhuskoder <- sjukhuskoder %>%
  rename(
    sjukhus = sjukhusnamn,
    region_sjh_txt = region
  ) %>%
  # Samredovisning av landsting SKAS
  mutate(
    sjukhus = ifelse(sjukhus %in% c("Skövde", "Lidköping"), "Skaraborg", sjukhus),
    sjukhus = ifelse(sjukhus %in% c("Enhet utan INCA-rapp", "VC/Tjänsteläkare"), NA, sjukhus)
  )

# Skapa shiny-applikationer ----------------------------------------------------

# Täckningsgrad
source("nkbc33_tackning_mot_cancerreg.R", encoding = "utf8")
source("nkbc13_tackning_for_preop_beh.R", encoding = "utf8")
source("nkbc14_tackning_for_postop_beh.R", encoding = "utf8")

# Population
source("nkbc09a_pop_kon.R", encoding = "utf8")
source("nkbc09b_pop_alder.R", encoding = "utf8")
source("nkbc09c_pop_invasiv.R", encoding = "utf8")
source("nkbc09d_pop_subtyp.R", encoding = "utf8")
source("nkbc09e_pop_n.R", encoding = "utf8")
source("nkbc09f_pop_m.R", encoding = "utf8")

# Ledtider
source("nkbc15_ledtid_misstanke_till_op.R", encoding = "utf8")
source("nkbc16_ledtid_misstanke_till_preop_beh.R", encoding = "utf8")
source("nkbc17_ledtid_misstanke_till_besok_spec.R", encoding = "utf8")
source("nkbc19_ledtid_behdisk_till_op.R", encoding = "utf8")
source("nkbc20_ledtid_behdisk_till_preop_beh.R", encoding = "utf8")
source("nkbc22_ledtid_op_till_cytostatikabeh.R", encoding = "utf8")
source("nkbc23_ledtid_op_till_stralbeh.R", encoding = "utf8")

# Diagnostik
source("nkbc01_diag_screening.R", encoding = "utf8")
source("nkbc04_diag_mdk_innan_beh.R", encoding = "utf8")
source("nkbc05_diag_mdk_efter_op.R", encoding = "utf8")
source("nkbc06_diag_klar_innan_op.R", encoding = "utf8")
source("nkbc10_diag_komplett_patologi.R", encoding = "utf8")

# Omvårdnad
source("nkbc02_omv_kontaktssk.R", encoding = "utf8")
source("nkbc03_omv_vardplan.R", encoding = "utf8")

# Kirurgi
source("nkbc40_kir_prim_beh.R", encoding = "utf8")
source("nkbc11_kir_brostbev_op.R", encoding = "utf8")
source("nkbc07_kir_direktrek.R", encoding = "utf8")
source("nkbc08_kir_omop.R", encoding = "utf8")
source("nkbc26_kir_sentinel_node.R", encoding = "utf8")

# Onkologisk behandling
source("nkbc35_onk_cytostatikabeh.R", encoding = "utf8")
source("nkbc27_onk_postop_cytostatikabeh_bland_erneg.R", encoding = "utf8")
source("nkbc28_onk_stralbeh_efter_brostbev_op.R", encoding = "utf8")
source("nkbc29_onk_stralbeh_efter_mastektomi.R", encoding = "utf8")
source("nkbc31_onk_endokrin_beh_maluppfyllelse.R", encoding = "utf8")
source("nkbc41_onk_endokrin_beh_fordelning.R", encoding = "utf8")
source("nkbc32_onk_antikroppbeh_bland_cytostatikabeh_her2pos.R", encoding = "utf8")

# Studier
source("nkbc39_pat_i_studie.R", encoding = "utf8")

# Överlevnad
source("nkbc30_overlevnad_5ar.R", encoding = "utf8")
