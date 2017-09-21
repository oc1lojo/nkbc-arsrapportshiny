######################################################
# Project: Årsrapport 2016
NAME <- "nkbc091"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Population - kön ------------------------------------------------
GLOBALS <- defGlobals(LAB = "Kön",
                      POP = "alla anmälda fall.",
                      SJHKODUSE <- "a_inr_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = factor(KON_VALUE, 
                 levels = c(1, 2),
                 labels = c("Män", "Kvinnor")
    )
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
    "Bröstcancer drabbar både män och kvinnor.", 
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
  )
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))