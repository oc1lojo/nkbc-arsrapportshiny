######################################################
# Project: Årsrapport
NAME <- "nkbc02"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated: se git 
######################################################


# Kontaktsjuksköterska ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Patienten har erbjudits, i journalen dokumenterad, kontaktsjuksköterska", 
                      POP = "alla anmälda fall.",
                      SHORTLAB = "Kontaktsjuksköterska", 
                      SJHKODUSE <- "a_inr_sjhkod",
                      TARGET = c(80, 95)
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_omv_kssk_Värde %in% c(0, 1), a_omv_kssk_Värde, NA))
  ) %>%
  filter(
    # kontaktsjuksköterska tillkom mitten av 2014
    period >= 2015,
    
    !is.na(region)
    
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv)


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
      "Enligt den Nationella  Cancerstrategin (SOU 2009:11) ska alla cancerpatienter erbjudas en kontaktsjuksköterska.", 
      descTarg()
    ),  
    descTolk, 
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
    )
  ),
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))