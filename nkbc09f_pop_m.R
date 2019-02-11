GLOBALS <- defGlobals(
  LAB = "Fjärrmetastaser vid diagnos",
  SHORTLAB = "Fjärrmetastaser",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # M
    outcome = factor(
      case_when(
        a_tnm_mklass_Värde == 0 ~ 1,
        a_tnm_mklass_Värde == 10 ~ 2,
        a_tnm_mklass_Värde == 20 ~ 99,
        is.na(a_tnm_mklass_Värde) ~ 99,
        TRUE ~ NA_real_
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
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = "nkbc09f",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    "Fall med fjärrmetastaser definieras som upptäckta inom 3 månader från provtagningsdatum (diagnosdatum).",
    paste0(
      "T.o.m. 2012 var det möjligt att registrera en tumör som att fjärrmetastaser ej kan bedömas (MX) i NKBC. Dessa har grupperats ihop med Uppgift saknas.
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
