GLOBALS <- defGlobals(
  LAB = "Cytostatikabehandling",
  POP = "opererade, invasiva fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "d_onk_sjhkod"
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, GLOBALS$SJHKODUSE) %>%
  mutate(
    # Pre eller postoperativ
    outcome = factor(
      case_when(
        post_kemo_Värde == 1 & pre_kemo_Värde == 1 ~ 1,
        pre_kemo_Värde == 1 ~ 0,
        post_kemo_Värde == 1 ~ 2,
        post_kemo_Värde == 0 | pre_kemo_Värde == 0 ~ 3
      ),
      levels = c(0, 1, 2, 3),
      labels = c(
        "Enbart preoperativ",
        "Både pre-och postoperativ",
        "Enbart postoperativ",
        "Ingen"
      )
    ),

    # ER
    d_er = factor(
      ifelse(is.na(d_er_Värde), 99, d_er_Värde),
      c(1, 2, 99),
      c("Positiv", "Negativ", "Uppgift saknas")
    )
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome, a_pat_alder,
    d_er, d_tstad, d_nstad
  )

rccShiny(
  data = dftemp,
  folder = "nkbc35",
  path = OUTPUTPATH,
  outcomeTitle = GLOBALS$LAB,
  folderLinkText = GLOBALS$SHORTLAB,
  geoUnitsPatient = FALSE,
  textBeforeSubtitle = GLOBALS$SHORTPOP,
  description = c(
    paste(
      "Pre- eller postoperativ cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
      sep = str_sep_description
    ),
    paste(
      "Tumörstorlek och spridning till lymfkörtlar är kliniskt diagnostiserat.",
      "För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation.",
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
    ),
    list(
      var = "d_tstad",
      label = c("Tumörstorlek")
    ),
    list(
      var = "d_nstad",
      label = c("Spridning till lymfkörtlar")
    ),
    list(
      var = "d_er",
      label = c("Östrogenreceptor (ER)")
    )
  )
)
