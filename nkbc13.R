######################################################
# Project: Årsrapport 2016
NAME <- "nkbc13"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Täckningsgrad för rapportering av preoperativ onkologisk behandling ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Täckningsgrad för rapportering av preoperativ onkologisk behandling",
                      POP = "opererade fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling.",
                      SHORTPOP = "fall utan fjärrmetastaser vid diagnos med preoperativ onkologisk behandling.",
                      SJHKODUSE <- "d_onkans_sjhkod",
                      TARGET = c(70, 85)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = ifelse(!is.na(pre_inr_dat) | !is.na(pre_inr_enh) | !is.na(pre_inr_initav), TRUE, FALSE)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat), 

    # Endast preoponk behandling (planerad om utförd ej finns)
    (op_kir_Värde %in% 2 | is.na(op_kir_Värde) & a_planbeh_typ_Värde %in% 2),
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% c(10),
    
    !is.na(region)
    
  ) %>%
  select(landsting, region, sjukhus, period, outcome, agegroup, invasiv)


link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste0(
      "Rapportering av given onkologisk behandling sker på ett eget formulär till kvalitetsregistret, separat från anmälan. Rapporteringen sker cirka 1 - 1,5 år efter anmälan.", 
      descTarg()
    ),
    paste0(
      onkRed,
      "<p></p>",
      descTolk
    ),
    descTekBes()
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))