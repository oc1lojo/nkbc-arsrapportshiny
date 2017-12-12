######################################################
# Project: Årsrapport 2016
NAME <- "nkbc096"
# Created by: Lina Benson 
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated by: 
# Updated date:
# Updated description: 
######################################################


# Population - Metastaser vid diagnos ------------------------------------------------
GLOBALS <- defGlobals(LAB = "Fjärrmetastaser vid diagnos",
                      SHORTLAB = "Fjärrmetastaser",
                      POP = "invasiva fall.",
                      SJHKODUSE <- "a_inr_sjhkod"
                      )

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # M
    outcome = factor(
      mapvalues(a_tnm_mklass_Värde, 
                from = c(0, 10, 20, NA), 
                to = c(1, 2, 3, 99)
      ),
      levels = c(1, 2, 3, 99),
      labels = c("Nej (M0)", "Ja (M1)", "Kan ej bedömas (MX)", "Uppgift saknas")
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
    "Fall med fjärrmetastaser definieras som upptäckta inom 3 månader från provtagningsdatum (diagnosdatum).", 
    paste0(
      "Fom 2013 är det inte längre möjligt att registrera en tumör som att fjärrmetastaser ej kan bedömas (MX) i NKBC.
      <p></p>",
      descTolk
    ),
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