######################################################
# Project: Årsrapport 2016
NAME <- "nkbc16"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Tid från välgrundad misstanke om cancer till onkologisk behandling (cytostatika, strålning, endokrin) ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Välgrundad misstanke till onkologisk behandling",
                      POP = "fall utan fjärrmetastaser vid diagnos med planerad preoperativ onkologisk behandling.",
                      SJHKODUSE <- "a_onk_sjhkod",
                      TARGET = c(75, 90)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    d_a_diag_misscadat = ifelse(!is.na(ymd(a_diag_misscadat)),
                                ymd(a_diag_misscadat), ymd(a_diag_kontdat)),
    
    d_pre_onk_dat = pmin(ymd(pre_kemo_dat), 
                         ymd(pre_rt_dat), 
                         ymd(pre_endo_dat), 
                         na.rm = TRUE),
    
    outcome = as.numeric(ymd(d_pre_onk_dat) - d_a_diag_misscadat),
    
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
    period >= 2013,
    
    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,
    
    # Endast opererade
    !is.na(op_kir_dat), 
    
    # Endast planerad preoperativ onkologisk behandling
    a_planbeh_typ_Värde %in% c(2),
    
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% c(10),
    !a_planbeh_typ_Värde %in% c(3),
    
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
    paste0(
      MisstCa,
      "<p></p>",
      descTolk
    ),
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
  propWithinValue = 28, 
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))
