######################################################
# Project: Årsrapport 2016
NAME <- "nkbc092"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Population - Ålder vid diagnos ------------------------------------------------
GLOBALS <- defGlobals(LAB = "Ålder vid diagnos",
                      SHORTLAB = "Ålder",
                      POP = "alla anmälda fall.",
                      SJHKODUSE <- "a_inr_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = a_pat_alder
  ) %>%
  filter(
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
    "Det är ovanligt med bröstcancer i unga år.", 
    descTolk, 
    descTekBes()
  ),
  varOther = list(
    list(
      var = "invasiv",
      label = c("Invasivitet")
    )
  ),
  propWithinUnit = "år",
  propWithinValue = 65
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))