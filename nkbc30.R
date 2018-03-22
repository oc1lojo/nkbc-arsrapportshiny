######################################################
# Project: Årsrapport
NAME <- "nkbc30"
# Created by: Lina Benson 
# Created date: 2017-08-10
# Software: R x64 v 3.3.3
# Status: 
# Updated: se git
######################################################


# 5 års överlevnad ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Observerad 5 års överlevnad",
                      POP = "alla anmälda fall.",
                      SJHKODUSE <- "a_inr_sjhkod",
                      TARGET = c(88, 100)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    lastdate = ymd(paste0(YEAR,"-12-31")),
    surv_time = ymd(VITALSTATUSDATUM_ESTIMAT) - ymd(a_diag_dat),
    outcome = surv_time >= 365.25*5
  ) %>%
  filter(
    # 5 års överlevnad så krävs 5 års uppföljning
    period <= YEAR - 5,
    
    !is.na(region)
  ) %>%
  select(landsting, region, period, outcome, a_pat_alder, invasiv, subtyp)


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
      "Total överlevnad betraktas som det viktigaste utfallsmåttet. Observerad överlevnad anger de bröstcancerfall som överlevt 5 år efter diagnos. Dödsorsakerna kan vara andra än bröstcancer.", 
      descTarg()
    ),
    paste0(
      "Uppgifter som rör 5 års överlevnad redovisas enbart tom ",YEAR - 5,".
      <p></p>",
      descTolk
    ),
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "invasiv",
      label = c("Invasivitet vid diagnos")
    ),
    list(
      var = "subtyp",
      label = c("Biologisk subtyp")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))