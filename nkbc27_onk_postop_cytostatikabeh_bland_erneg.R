GLOBALS <- defGlobals(
  LAB = "Postoperativ cytostatikabehandling",
  POP = "primärt opererade östrogenreceptornegativa invasiva fall med tumörstorlek > 10mm eller spridning till lymfkörtlar utan fjärrmetastaser vid diagnos.",
  SHORTPOP = "primärt opererade ER- invasiva fall med större tumörer utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "post_inr_sjhkod",
  TARGET = c(80, 90)
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
  mutate(
    outcome = as.logical(post_kemo_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast primär opereration (planerad om utfärd ej finns)
    # (pga att info om tumörstorlek och spridning till N behövs)
    d_prim_beh_Värde == 1,

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # ER-
    d_er_Värde == 2,

    # Tumörstorlek > 10 mm eller spridning till lymfkörtlar
    (op_pad_invstl > 10 | op_pad_lglmetant > 0),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = "nkbc27",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
      descTarg(),
      sep = str_sep_description
    ),
    paste(
      "Enbart postoperativ cytostatikabehandling är medtaget i beräkningen, vilket innebär att andelen kan bli mindre för de sjukhus där cytostatika i större utsträckning ges preoperativt.",
      "Tumörstorlek är storlek på den största invasiva tumören, det innebär att det kan finnas multifokala fall där den totala extenten är > 10 mm som inte finns medtagna i urvalet.",
      "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen.",
      onkRed,
      descTolk,
      sep = str_sep_description
    ),
    paste(
      descTekBes(),
      sep = str_sep_description
    )
  ),
  varOther = list(
    list(
      var = "a_pat_alder",
      label = c("Ålder vid diagnos")
    )
  ),
  targetValues = GLOBALS$TARGET
)
