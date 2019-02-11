# Ladda paket ------------------------------------------------------------------

# devtools::install_bitbucket("cancercentrum/rccShiny")
library(plyr)
library(dplyr)
library(lubridate)
library(shiny)
library(rccShiny)
library(Hmisc)

# Läs in/Definera "konstanter" och hjälpfunktioner -----------------------------

YEAR <- 2017
OUTPUTPATH <- "Output"

source("beskTXT.R", encoding = "utf8")

addSjhData <- function(df = dfmain, SJHKODUSE = GLOBALS$SJHKODUSE) {
  names(df)[names(df) == SJHKODUSE] <- "sjhkod"

  df[, "sjhkod"] <- as.numeric(df[, "sjhkod"])

  df <- left_join(df,
    sjukhuskoder,
    by = c("sjhkod" = "sjukhuskod")
  ) %>%
    mutate(
      region = mapvalues(region_sjh_txt,
        from = c("Sthlm/Gotland", "Uppsala/Örebro", "Sydöstra", "Syd", "Väst", "Norr"),
        to = c(1, 2, 3, 4, 5, 6)
      ) %>% as.integer(),
      region = ifelse(is.na(region), region_lkf, region),
      landsting = substr(sjhkod, 1, 2) %>% as.integer(),
      # Fulfix Bröstmottagningen, Christinakliniken Sh & Stockholms bröstklinik så hamnar i Stockholm
      landsting = ifelse(sjhkod %in% c(97333, 97563), 10, landsting),
      landsting = ifelse(landsting %in% c(
        seq(10, 13),
        seq(21, 28),
        30,
        seq(41, 42),
        seq(50, 57),
        seq(61, 65)
        # seq(91,96)
      ),
      landsting,
      NA
      )
    )
  return(df)
}

# Läs in data ------------------------------------------------------------------

# Rottabell
load(unzip("G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Data/2018-08-31/nkbc_nat_id 2018-08-31 09-22-09.zip", exdir = tempdir()))

# Läs på namn på sjukhus (hämta från organisationsenhetsregistret i framtiden)
load("G:/Hsf/RCC-Statistiker/_Generellt/INCA/Data/sjukhusKlinikKoder/sjukhuskoder.RData")

# Läs in data för täckningsgrad mot cancerregistret
tackning_tbl <- readxl::read_excel("G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Utdata/Arsrapport/2017.2/Täckningsgrader/Tackningsrader_alla_regioner.xlsx")

# Bearbeta data ----------------------------------------------------------------

# Bearbeta huvud-dataram
dfmain <- df %>%
  mutate_if(is.factor, as.character) %>%
  mutate(
    period = year(a_diag_dat), # Den period som appar visas för
    opyear = year(op_kir_dat),
    # landsting_lkf = as.numeric(substr(a_pat_lkfdia, 1, 2)),
    # landsting_lkf = ifelse(landsting_lkf %in% c(1, seq(3, 10), seq(12, 14), seq(17, 25)),
    #   landsting_lkf,
    #   NA
    # ),

    # lkf region för att imputera om region för sjukhus saknas
    region_lkf = mapvalues(REGION_NAMN,
      from = c(
        "Region Sthlm/Gotland", "Region Uppsala/Örebro", "Region Sydöstra",
        "Region Syd", "Region Väst", "Region Norr"
      ),
      to = c(1, 2, 3, 4, 5, 6)
    ) %>% as.integer(),

    # Derivering av primär behandling
    prim_beh = coalesce(op_kir_Värde, a_planbeh_typ_Värde),

    # Derivering av invasiv cancer
    invasiv = ifelse(prim_beh == 1, op_pad_invasiv_Värde,
      ifelse(prim_beh %in% c(2, 3) | is.na(prim_beh), a_pad_invasiv_Värde,
        NA
      )
    ),

    invasiv = ifelse(invasiv == 98, NA, invasiv), ## added 2017-11-09
    invasiv = factor(invasiv, c(1, 2, NA),
      c("Invasiv cancer", "Enbart cancer in situ", "Uppgift saknas"),
      exclude = NULL
    ),

    # Biologisk subtyp
    # ER, 1 = pos, 2 = neg
    er_op = case_when(
      op_pad_erproc < 10 | is.na(op_pad_erproc) & op_pad_er_Värde %in% 2 ~ 2,
      op_pad_erproc >= 10 | is.na(op_pad_erproc) & op_pad_er_Värde %in% 1 ~ 1
    ),

    er_a = case_when(
      a_pad_erproc < 10 | is.na(a_pad_erproc) & a_pad_er_Värde %in% 2 ~ 2,
      a_pad_erproc >= 10 | is.na(a_pad_erproc) & a_pad_er_Värde %in% 1 ~ 1
    ),

    er = ifelse(prim_beh == 1, er_op,
      ifelse(prim_beh %in% c(2, 3), er_a,
        NA
      )
    ),

    # PR, 1 = pos, 2 = neg
    pr_op = case_when(
      op_pad_prproc < 10 | is.na(op_pad_prproc) & op_pad_pr_Värde %in% 2 ~ 2,
      op_pad_prproc >= 10 | is.na(op_pad_prproc) & op_pad_pr_Värde %in% 1 ~ 1
    ),

    pr_a = case_when(
      a_pad_prproc < 10 | is.na(a_pad_prproc) & a_pad_pr_Värde %in% 2 ~ 2,
      a_pad_prproc >= 10 | is.na(a_pad_prproc) & a_pad_pr_Värde %in% 1 ~ 1
    ),

    pr = ifelse(prim_beh == 1, pr_op,
      ifelse(prim_beh %in% c(2, 3), pr_a,
        NA
      )
    ),

    # HER2, 1 = pos, 2 = neg
    her2_op = case_when(
      op_pad_her2_Värde %in% 3 | op_pad_her2ish_Värde %in% 1 ~ 1,
      op_pad_her2_Värde %in% c(1, 2) | op_pad_her2ish_Värde %in% 2 ~ 2
    ),

    her2_a = case_when(
      a_pad_her2_Värde %in% 3 | a_pad_her2ish_Värde %in% 1 ~ 1,
      a_pad_her2_Värde %in% c(1, 2) | a_pad_her2ish_Värde %in% 2 ~ 2
    ),

    her2 = ifelse(prim_beh == 1, her2_op,
      ifelse(prim_beh %in% c(2, 3), her2_a,
        NA
      )
    ),

    subtyp = factor(case_when(
      er %in% 2 & pr %in% 2 & her2 %in% 2 ~ 1,
      is.na(er) | is.na(pr) | is.na(her2) ~ 99,
      her2 %in% 1 ~ 2,
      er %in% 1 | pr %in% 1 ~ 3,
      TRUE ~ 99
    ),
    labels = c("Trippel negativ", "HER2 positiv", "Luminal", "Uppgift saknas")
    ),

    # fix 1.sjukhus ansvarigt för rapportering av onkologisk behandling/2.onkologiskt sjukhus/3.anmälande sjukhus
    d_onkpostans_sjhkod = coalesce(
      as.numeric(post_inr_sjhkod),
      as.numeric(op_onk_sjhkod),
      as.numeric(a_onk_rappsjhkod),
      as.numeric(a_onk_sjhkod),
      as.numeric(a_inr_sjhkod)
    ),
    d_onkpreans_sjhkod = coalesce(
      as.numeric(pre_inr_sjhkod),
      as.numeric(op_onk_sjhkod),
      as.numeric(a_onk_rappsjhkod),
      as.numeric(a_onk_sjhkod),
      as.numeric(a_inr_sjhkod)
    ),
    # fix 1) post onk sjukhus 2) pre onk sjukhus
    d_onk_sjhkod = coalesce(
      as.numeric(post_inr_sjhkod),
      as.numeric(pre_inr_sjhkod)
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
source("nkbc091_pop_kon.R", encoding = "utf8")
source("nkbc092_pop_alder.R", encoding = "utf8")
source("nkbc093_pop_invasiv.R", encoding = "utf8")
source("nkbc094_pop_subtyp.R", encoding = "utf8")
source("nkbc095_pop_n.R", encoding = "utf8")
source("nkbc096_pop_m.R", encoding = "utf8")

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
