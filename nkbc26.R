######################################################
# Project: Årsrapport 2016
NAME <- "nkbc26"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: 
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Sentinel node operation ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Sentinel node operation",
                      POP = "invasiva fall utan spridning till lymfkörtlar (klinisk diagnos) eller fjärrmetastaser vid diagnos.",
                      SHORTPOP = "invasiva fall utan spridning till lymfkörtlar eller fjärrmetastaser vid diagnos.",
                      SJHKODUSE <- "a_kir_sjhkod",
                      TARGET = c(90, 95)
                      )


dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = mapvalues(op_kir_axilltyp_Värde, from = c(1, 2, 3, 4, 98), to = c(1, 0, 1, 0, NA)), 
    outcome = as.logical(ifelse(op_kir_axill_Värde %in% 0, 0, outcome))
  ) %>%
  filter(
    # Endast invasiv cancer
    invasiv == "Invasiv",
    
    # Klinisk N0 
    a_tnm_nklass_Värde %in% c(0),
    
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
      "Kännedom om tumörspridning till axillens lymfkörtlar vägleder behandlingsrekommendationer. Sentinelnodetekniken minskar risken för armbesvär då endast ett fåtal (1–4) körtlar tas bort.", 
      descTarg()
    ),
    descTolk,
    descTekBes()
  ),
  varOther = list(
    list(
      var = "agegroup",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))