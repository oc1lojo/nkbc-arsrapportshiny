######################################################
# Project: Årsrapport 2016
NAME <- "nkbc20"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Tid från första behandlingsdiskussion till preoperativ onkologisk behandling (cytostatika, strålning, endokrin) ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Första behandlingsdiskussion till onkologisk behandling",
                      POP = "fall utan fjärrmetastaser vid diagnos med planerad preoperativ onkologisk behandling.",
                      SJHKODUSE <- "a_onk_sjhkod",
                      TARGET = c(75, 90)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_pre_onk_dat = pmin(as.Date(pre_kemo_dat), 
                         as.Date(pre_rt_dat), 
                         as.Date(pre_endo_dat), 
                         na.rm = TRUE),
    
    outcome = as.numeric(ymd(d_pre_onk_dat) - ymd(a_planbeh_infopatdat)),
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat), 
    
    # Endast preop onk behandling (planerad om utförd ej finns)
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
      "I preoperativ onkologisk behandling ingår cytostatika, strålning eller endokrin behandling.
      <p></p>
      Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.", 
      descTarg()
    ),     
    descTolk,
    descTekBes()
  ),
  varOther = list(
    list(
      var = "agegroup",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet")
    )
  ),
  propWithinValue = 14, 
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))