GLOBALS <- defGlobals(
  LAB = "Spridning till lymfkörtlarna (klinisk) vid diagnos",
  SHORTLAB = "Spridning till lymfkörtlarna",
  POP = "alla anmälda fall.",
  SJHKODUSE = "a_inr_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    # N
    outcome = factor(
      case_when(
        a_tnm_nklass_Värde == 0 ~ 1,
        a_tnm_nklass_Värde == 10 ~ 2,
        a_tnm_nklass_Värde == 20 ~ 2,
        a_tnm_nklass_Värde == 30 ~ 2,
        a_tnm_nklass_Värde == 40 ~ 99,
        is.na(a_tnm_nklass_Värde) ~ 99,
        TRUE ~ NA_real_
      ),
      levels = c(1, 2, 99),
      labels = c("Nej (N0)", "Ja (N1-N3)", "Uppgift saknas")
    )
  ) %>%
  filter(
    # Endast invasiv cancer
    # invasiv == "Invasiv cancer", Bortselekterat pga om väljer enbart invasiv
    # cancer så tas alla med uppgift saknas på invasiv bort. Dock några fel? reg
    # in situ och N1 men men...

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv)

rccShiny(
  data = dftemp,
  folder = "nkbc09e",
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
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  )
)
