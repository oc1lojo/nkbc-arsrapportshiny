nkbc27_def <- list(
  code = "nkbc27",
  lab = "Postoperativ cytostatikabehandling",
  pop = "primärt opererade östrogenreceptornegativa invasiva fall med tumörstorlek > 10mm eller spridning till lymfkörtlar utan fjärrmetastaser vid diagnos",
  pop_short = "primärt opererade ER- invasiva fall med större tumörer utan fjärrmetastaser vid diagnos",
  target_values = c(80, 90),
  sjhkod_var = "post_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
  vid_tolkning =
    c(
      "Enbart postoperativ cytostatikabehandling är medtaget i beräkningen, vilket innebär att andelen kan bli mindre för de sjukhus där cytostatika i större utsträckning ges preoperativt.",
      "Tumörstorlek är storlek på den största invasiva tumören, det innebär att det kan finnas multifokala fall där den totala extenten är > 10 mm som inte finns medtagna i urvalet.",
      "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen."
    ),
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc27_def$sjhkod_var) %>%
  mutate(
    outcome = as.logical(post_kemo_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

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
  folder = nkbc27_def$code,
  path = output_path,
  outcomeTitle = nkbc27_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc27_def),
  description = compile_description(nkbc27_def, report_end_year),
  varOther = compile_varOther(nkbc27_def),
  targetValues = nkbc27_def$target_values
)
