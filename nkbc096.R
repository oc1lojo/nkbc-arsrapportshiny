######################################################
# Project: Årsrapport
NAME <- "nkbc096"
# Created by: Lina Benson
# Created date: 2017-08-09
# Software: R x64 v 3.3.3
# Status: Final
# Updated: se git
######################################################


# Population - Metastaser vid diagnos ------------------------------------------------
GLOBALS <- defGlobals(
  LAB = "Fjärrmetastaser vid diagnos",
  SHORTLAB = "Fjärrmetastaser",
  POP = "alla anmälda fall.",
  SJHKODUSE <- "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # M
    outcome = factor(
      mapvalues(a_tnm_mklass_Värde,
        from = c(0, 10, 20, NA),
        to = c(1, 2, 99, 99)
      ),
      levels = c(1, 2, 99),
      labels = c("Nej (M0)", "Ja (M1)", "Uppgift saknas")
    )
  ) %>%
  filter(
    # Endast invasiv cancer
    # invasiv == "Invasiv cancer", Bortselekterat pga om väljer enbart invasiv
    # cancer så tas alla med uppgift saknas på invasiv bort. Dock några fel? reg
    # in situ och M1 men men...

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
    "Fall med fjärrmetastaser definieras som upptäckta inom 3 månader från provtagningsdatum (diagnosdatum).",
    paste0(
      "Tom 2012 var det möjligt att registrera en tumör som att fjärrmetastaser ej kan bedömas (MX) i NKBC. Dessa har grupperats ihop med Uppgift saknas. 
      <p></p>",
      descTolk
    ),
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  )
)

cat(link)
# runApp(paste0("Output/apps/sv/",NAME))
