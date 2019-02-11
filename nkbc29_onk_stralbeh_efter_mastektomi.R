GLOBALS <- defGlobals(
  LAB = "Strålbehandling efter mastektomi",
  POP = "invasiva fall med mastektomi, spridning till lymfkörtlarna och utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "post_inr_sjhkod",
  TARGET = c(90, 95)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.logical(post_rt_Värde),

    pN = cut(op_pad_lglmetant, c(1, 4, 100),
      include.lowest = TRUE,
      right = FALSE,
      labels = c("1-3 metastaser", "=> 4 metastaser")
    )
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

    # Endast invasiv cancer
    invasiv == "Invasiv cancer",

    # Endast mastektomi och subkutan mastektomi
    op_kir_brost_Värde %in% c(2, 4),

    # Spridning till lymfkörtlar
    op_pad_lglmetant > 0,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv, pN)

rccShiny(
  data = dftemp,
  folder = "nkbc29",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste0(
      "Då hela bröstet opererats bort (mastektomi) behövs oftast inte strålbehandling, lokoregional strålbehandling för patienter med endast mikrometastas rekommenderas inte. Vid spridning till lymfkörtlar bör strålbehandling ges både mot bröstkorgsväggen och lymfkörtlar.",
      descTarg()
    ),
    paste0(
      "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen.
      <p></p>",
      onkRed,
      "<p></p>",
      descTolk
    ),
    descTekBes()
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    ),
    list(
      var = "pN",
      label = c("Spridning till lymfkörtlar")
    )
  ),
  targetValues = GLOBALS$TARGET
)
