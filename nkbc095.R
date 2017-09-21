######################################################
# Project: Årsrapport 2016
NAME <- "nkbc095"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Population - Spridning till lymfkörtlarna (klinisk) ------------------------------------------------
GLOBALS <- defGlobals(LAB = "Spridning till lymfkörtlarna (klinisk) vid diagnos",
                      SHORTLAB = "Spridning till lymfkörtlarna",
                      POP = "invasiva fall.",
                      SJHKODUSE <- "a_inr_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # N
    outcome = factor(
      mapvalues(a_tnm_nklass_Värde, 
                from = c(0, 10, 20, 30, 40, NA), 
                to = c(1, 2, 2, 2, 99, 99)
      ),
      levels = c(1, 2, 99),
      labels = c("Nej (N0)", "Ja (N1-N3)", "Uppgift saknas")
    )
  ) %>%
  filter(
    # Endast invasiv cancer
    invasiv == "Invasiv",
    
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
    "Kännedom om tumörspridning till axillens lymfkörtlar ger vägledning för behandling och information om prognos. Grundas på bilddiagnostik och klinisk undersökning.", 
    descTolk, 
    descTekBes()
  ),
  varOther = list(
    list(
      var = "agegroup",
      label = c("Ålder vid diagnos")
    )
  )
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))