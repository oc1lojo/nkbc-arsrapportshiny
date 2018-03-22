######################################################
# Project: Årsrapport
# Name: MAIN.R
# Created by: Lina Benson 
# Created date: 2017-06-16
# Software: R x64 v 3.3.3
# Status: 
# Updated: se git 
######################################################

#devtools::install_bitbucket("cancercentrum/rccShiny")

library(plyr)
library(dplyr)
library(lubridate)
library(shiny)
library(rccShiny)
library(Hmisc)

## Ändra dataset
load(unzip("G:/Hsf/RCC-Statistiker/Brostcancer/Brostcancer/Data/2018-03-14/nkbc_nat_id 2018-03-14 09-23-02.zip", exdir = tempdir()))

YEAR = 2017
OUTPUTPATH = "Output"

dfmain <- df %>%
  mutate_if(is.factor, as.character) %>%
  mutate(
    period = year(a_diag_dat), # Den period som appar visas för 
    opyear = year(op_kir_dat),
#    landsting_lkf = as.numeric(substr(a_pat_lkfdia, 1, 2)),
#    landsting_lkf = ifelse(landsting_lkf %in% c(1, seq(3,10), seq(12,14), seq(17,25)), 
#                                                landsting_lkf, 
#                                                NA),

    # lkf region för att imputera om region för sjukhus saknas
    region_lkf = mapvalues(REGION_NAMN, from = c("Region Sthlm/Gotland", "Region Uppsala/Örebro", "Region Sydöstra", 
                                                 "Region Syd", "Region Väst", "Region Norr"), 
                       to = c(1, 2, 3, 4, 5, 6)),
    
    # Derivering av invasiv cancer
    invasiv = pmin(a_pad_invasiv_Värde, op_pad_invasiv_Värde, na.rm = TRUE),
    invasiv = ifelse(invasiv == 98, NA, invasiv), ## added 2017-11-09
    invasiv = factor(invasiv, c(1, 2, NA), 
                     c("Invasiv cancer", "Enbart cancer in situ", "Uppgift saknas"),
                     exclude = NULL),
    
    # Derivering av primär operation
    prim_op = coalesce(op_kir_Värde, a_planbeh_typ_Värde),

    # Biologisk subtyp 
    # ER, 1 = pos, 2 = neg
    er_op = case_when(op_pad_erproc < 10 | is.na(op_pad_erproc) & op_pad_er_Värde %in% 2 ~ 2,
                      op_pad_erproc >= 10 | is.na(op_pad_erproc) & op_pad_er_Värde %in% 1 ~ 1
                      ),

    er_a = case_when(a_pad_erproc < 10 | is.na(a_pad_erproc) & a_pad_er_Värde %in% 2 ~ 2,
                     a_pad_erproc >= 10 | is.na(a_pad_erproc) & a_pad_er_Värde %in% 1 ~ 1
                     ),

    er = ifelse(prim_op  == 1, er_op, 
                ifelse(prim_op %in% c(2, 3), er_a, 
                       NA)),
    
    # PR, 1 = pos, 2 = neg
    pr_op = case_when(op_pad_prproc < 10 | is.na(op_pad_prproc) & op_pad_pr_Värde %in% 2 ~ 2,
                      op_pad_prproc >= 10 | is.na(op_pad_prproc) & op_pad_pr_Värde %in% 1 ~ 1
                      ),

    pr_a = case_when(a_pad_prproc < 10 | is.na(a_pad_prproc) & a_pad_pr_Värde %in% 2 ~ 2,
                     a_pad_prproc >= 10 | is.na(a_pad_prproc) & a_pad_pr_Värde %in% 1 ~ 1
                     ),

    pr = ifelse(prim_op == 1, pr_op, 
                ifelse(prim_op %in% c(2, 3), pr_a, 
                       NA)),
     
    # HER2, 1 = pos, 2 = neg
    her2_op = case_when(op_pad_her2_Värde %in% 3 | op_pad_her2ish_Värde %in% 1 ~ 1, 
                        op_pad_her2_Värde %in% c(1,2) | op_pad_her2ish_Värde %in% 2 ~ 2),

    her2_a = case_when(a_pad_her2_Värde %in% 3 | a_pad_her2ish_Värde %in% 1 ~ 1, 
                       a_pad_her2_Värde %in% c(1,2) | a_pad_her2ish_Värde %in% 2 ~ 2),

    her2 = ifelse(prim_op == 1, her2_op, 
                  ifelse(prim_op %in% c(2, 3), her2_a, 
                         NA)),
               
    subtyp = factor(case_when(er %in% 2 & pr %in% 2 & her2 %in% 2 ~ 1, 
                              her2 %in% 1 ~ 2,
                              er %in% 1 | pr %in% 1 ~ 3, 
                              TRUE ~ 99
                              ), 
                   labels = c("Trippel negativ", "HER2 positiv", "Luminal", "Uppgift saknas") 
                   ),
    
    # fix 1.sjukhus ansvarigt för rapportering av onkologisk behandling/2.onkologiskt sjukhus/3.anmälande sjukhus
    d_onkans_sjhkod = coalesce(as.numeric(op_onk_sjhkod), 
                               as.numeric(a_onk_rappsjhkod), 
                               as.numeric(a_onk_sjhkod), 
                               as.numeric(a_inr_sjhkod)
                               ),

    # fix 1.sjukhus ansvarigt för rapportering av uppföljning/2.onkologiskt sjukhus/3.anmälande sjukhus
    d_uppfans_sjhkod = coalesce(as.numeric(op_uppf_sjhkod), 
                               as.numeric(a_uppf_sjhkod), 
                               as.numeric(a_onk_sjhkod), 
                               as.numeric(a_inr_sjhkod)
    )
  ) %>%
  filter( # default vilka år som ska visas
    period >= 2009,
    period <= YEAR
)

# Läsa på namn på sjukhus (hämtat från organisationsenhetsregistret)
load("G:/Hsf/RCC-Statistiker/_Generellt/INCA/Data/sjukhusKlinikKoder/sjukhuskoder.RData")

sjukhuskoder <- sjukhuskoder %>%
  rename(sjukhus = sjukhusnamn,
         region_sjh_txt = region
  ) %>%
  # Samredovisning av landsting SKAS
  mutate(sjukhus = ifelse(sjukhus %in% c("Skövde", "Lidköping"), "Skaraborg", sjukhus),
         sjukhus = ifelse(sjukhus %in% c("Enhet utan INCA-rapp", "VC/Tjänsteläkare"), NA, sjukhus)
  )

addSjhData <- function(df = dfmain, SJHKODUSE = GLOBALS$SJHKODUSE){
  
  names(df)[names(df) == SJHKODUSE] <- "sjhkod"
  
  df[,"sjhkod"] <- as.numeric(df[,"sjhkod"])
  
  df <- left_join(df, 
                  sjukhuskoder, 
                  by = c("sjhkod" = "sjukhuskod")
                  ) %>%
    mutate(
      region = mapvalues(region_sjh_txt, from = c("Sthlm/Gotland", "Uppsala/Örebro", "Sydöstra", "Syd", "Väst", "Norr"), 
                           to = c(1, 2, 3, 4, 5, 6)),
      region = ifelse(is.na(region), region_lkf, region),
      landsting = substr(sjhkod, 1, 2), 
      # Fulfix Bröstmottagningen, Christinakliniken Sh & Stockholms bröstklinik så hamnar i Stockholm
      landsting = ifelse(sjhkod %in% c(97333, 97563), 10, landsting),
      landsting = ifelse(landsting %in% c(seq(10,13), 
                                                seq(21,28), 
                                                30, 
                                                seq(41, 42), 
                                                seq(50, 57),
                                                seq(61, 65)
                                                #seq(91,96)
    ),
    landsting, 
    NA)
  )
  return(df)
}


source("beskTXT.R", encoding = "utf8")

source("nkbc01.R", encoding = "utf8")
source("nkbc02.R", encoding = "utf8")
source("nkbc03.R", encoding = "utf8")
source("nkbc04.R", encoding = "utf8") 
source("nkbc05.R", encoding = "utf8") 
source("nkbc06.R", encoding = "utf8")
source("nkbc07.R", encoding = "utf8")
source("nkbc08.R", encoding = "utf8")
source("nkbc091.R", encoding = "utf8") 
source("nkbc092.R", encoding = "utf8") 
source("nkbc093.R", encoding = "utf8") 
source("nkbc094.R", encoding = "utf8") 
source("nkbc095.R", encoding = "utf8") 
source("nkbc096.R", encoding = "utf8") 
source("nkbc10.R", encoding = "utf8")
source("nkbc11.R", encoding = "utf8")
source("nkbc13.R", encoding = "utf8") 
source("nkbc14.R", encoding = "utf8") 
source("nkbc15.R", encoding = "utf8")
source("nkbc16.R", encoding = "utf8")
source("nkbc17.R", encoding = "utf8")
#source("nkbc18.R", encoding = "utf8") utgår pga 0 tider
source("nkbc19.R", encoding = "utf8")
source("nkbc20.R", encoding = "utf8")
#source("nkbc21.R", encoding = "utf8") utgår pga 0 tider
source("nkbc22.R", encoding = "utf8")
source("nkbc23.R", encoding = "utf8")
source("nkbc24.R", encoding = "utf8") 
source("nkbc25.R", encoding = "utf8") 
source("nkbc26.R", encoding = "utf8")
source("nkbc27.R", encoding = "utf8")
source("nkbc28.R", encoding = "utf8")
source("nkbc29.R", encoding = "utf8")
source("nkbc30.R", encoding = "utf8") 
source("nkbc31.R", encoding = "utf8") 
source("nkbc32.R", encoding = "utf8") 
source("nkbc33.R", encoding = "utf8") 
source("nkbc34.R", encoding = "utf8")
source("nkbc35.R", encoding = "utf8")

#detach("package:rccShiny", unload=TRUE)