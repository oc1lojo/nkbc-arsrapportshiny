######################################################
# Project: Årsrapport 2016
NAME <- "nkbc01"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Screeningupptäckt bröstcancer ------------------------------------------------

GLOBALS <- defGlobals(LAB = "Screeningupptäckt bröstcancer", 
                      POP = "kvinnor i åldrarna 40-74 år vid diagnos.",
                      SJHKODUSE <- "a_inr_sjhkod",
                      TARGET = c(60, 70) 
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    a_pat_alder = as.numeric(a_pat_alder),
    
    # Hantera missing
    outcome = as.logical(ifelse(a_diag_screening_Värde %in% c(0,1), a_diag_screening_Värde, NA))
  ) %>%
  filter(
    # Ålder 40-74 år vid diagnos
    a_pat_alder <= 74,
    a_pat_alder >= 40,
    
    # Enbart kvinnor
    KON_VALUE == 2,

    !is.na(region)
    
  ) %>%
  select(landsting, region, sjukhus, period, outcome, agegroup, invasiv)


link <- rccShiny(
  data = dftemp,
  folder = NAME,
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste0(
      "Mammografiscreening erbjuds alla kvinnor mellan 40–74 år.", 
      descTarg()
      ),  
    paste0(
      "Definitionen av \"screeningupptäckt fall\" kan enligt erfarenhet tolkas olika vilket kan påverka siffrorna. 
      Enligt kvalitetsregistret avses enbart de fall som diagnostiserats i samband med en kallelese till den landstingsorganiserade screeningmammografin. 
      <p></p>
      Det finns en osäkerhet avseende andel scrreningupptäckta fall då det på vissa orter bara finns en mammografinenhet som både utför screening och klinisk mammografi.
      <p></p>",
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
  targetValues = GLOBALS$TARGET
)

cat(link)
#runApp(paste0("Output/apps/sv/",NAME))


