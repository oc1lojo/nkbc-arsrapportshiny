# Läs in R-paket och verktygsfunktioner ----------------------------------------
library(dplyr)
library(lubridate)
library(shiny)
library(rccShiny)

for (file_name in list.files("nkbcgeneral", pattern = "*.R")) {
  source(file.path("nkbcgeneral", file_name), encoding = "UTF-8")
}
for (file_name in list.files("nkbcind", pattern = "*.R")) {
  source(file.path("nkbcind", file_name), encoding = "UTF-8")
}

# Temporär work-around för att hantera NULL. TODO Bättre lösning
one_of <- function(x, ...) if (!is.null(x)) dplyr::one_of(x, ...)

# Definera globala variabler ---------------------------------------------------
report_end_year <- 2017
output_path <- "output"

# Läs in data ------------------------------------------------------------------

# Läs in namn på sjukhus (hämta från organisationsenhetsregistret i framtiden)
load("G:/Hsf/RCC-Statistiker/_Generellt/INCA/Data/sjukhusKlinikKoder/sjukhuskoder.RData")

# Läs in ögonblickskopia av NKBC exporterad från INCA
nkbc_data_dir <- Sys.getenv("NKBC_DATA_DIR")
load(
  unzip(
    file.path(nkbc_data_dir, "2018-08-31", "nkbc_nat_id 2018-08-31 09-22-09.zip"),
    exdir = tempdir()
  )
)

# Läs in data för täckningsgrad mot cancerregistret
tackning_tbl <- readxl::read_excel(
  "G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Utdata/Arsrapport/2017.2/Täckningsgrader/Tackningsrader_alla_regioner.xlsx"
)

# Bearbeta data ----------------------------------------------------------------

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

# Bearbeta huvud-dataram
df_main <- df %>%
  mutate_if(is.factor, as.character) %>%
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

# Skapa interaktiva rapporter --------------------------------------------------

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
