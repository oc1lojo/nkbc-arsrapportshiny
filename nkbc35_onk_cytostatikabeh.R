GLOBALS <- defGlobals(
  LAB = "Cytostatikabehandling",
  POP = "opererade, invasiva fall utan fjärrmetastaser vid diagnos.",
  SJHKODUSE = "d_onk_sjhkod"
)

dftemp <- addSjhData(dfmain)

dftemp <- dftemp %>%
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

    # T
    Tstad = factor(
      case_when(
        a_tnm_tklass_Värde == 0 ~ 1,
        a_tnm_tklass_Värde == 5 ~ 1,
        a_tnm_tklass_Värde == 10 ~ 1,
        a_tnm_tklass_Värde == 20 ~ 2,
        a_tnm_tklass_Värde == 30 ~ 2,
        a_tnm_tklass_Värde == 42 ~ 2,
        a_tnm_tklass_Värde == 44 ~ 2,
        a_tnm_tklass_Värde == 45 ~ 2,
        a_tnm_tklass_Värde == 46 ~ 2,
        a_tnm_tklass_Värde == 50 ~ 99,
        is.na(a_tnm_tklass_Värde) ~ 99,
        TRUE ~ NA_real_
      ),
      levels = c(1, 2, 99),
      labels = c("<=20mm (T0/T1)", ">20mm (T2-T4)", "Uppgift saknas")
    ),

    # N
    Nstad = factor(
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
    ),

    # ER
    er = ifelse(is.na(er), 99, er),
    er = factor(er, c(1, 2, 99), c("Positiv", "Negativ", "Uppgift saknas"))
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= YEAR - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast invasiv cancer
    invasiv == "Invasiv cancer",

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome, a_pat_alder, invasiv,
    er, Tstad, Nstad
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
    paste0(
      "Pre- eller postoperativ cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer."
    ),
    paste0(
      "Tumörstorlek och spridning till lymfkörtlar är kliniskt diagnostiserat.
      <p></p>
      För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation.
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
      var = "Tstad",
      label = c("Tumörstorlek")
    ),
    list(
      var = "Nstad",
      label = c("Spridning till lymfkörtlar")
    ),
    list(
      var = "er",
      label = c("Östrogenreceptor (ER)")
    )
  )
)
