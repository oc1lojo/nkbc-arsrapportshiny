######################################################
# Project: Årsrapport 2016
NAME <- "nkbc07"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Omedelbara rekonstruktioner vid mastektomi ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Omedelbara rekonstruktioner vid mastektomi",
                      POP = "mastektomerade fall utan fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_kir_sjhkod",
                      TARGET = c(15, 20)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(op_kir_dirrek_Värde %in% c(0, 1), op_kir_dirrek_Värde, NA))
  ) %>%
  filter(
    # Endast mastektomi 
    op_kir_brost_Värde %in% c(2,4),
    
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
      "Omedelbar rekonstruktion innebär att en bröstform återskapas i samband med att ett helt bröst opereras bort.", 
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
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))