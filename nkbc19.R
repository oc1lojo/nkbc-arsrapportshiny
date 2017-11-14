######################################################
# Project: Årsrapport 2016
NAME <- "nkbc19"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Tid från första behandlingsdiskussion till operation ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Första behandlingsdiskussion till operation",
                      POP = "primärt opererade fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_kir_sjhkod",
                      TARGET = c(75, 90)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.numeric(ymd(op_kir_dat) - ymd(a_planbeh_infopatdat)),
    
    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat), 
    
    # Endast primär opereration (planerad om utförd ej finns)
    (op_kir_Värde %in% 1 | is.na(op_kir_Värde) & a_planbeh_typ_Värde %in% 1),
    
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
      "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.", 
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