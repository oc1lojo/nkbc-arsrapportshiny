nkbc32_def <- list(
  code = "nkbc32",
  lab = "Antikroppsbehandling bland cytostatikabehandlade",
  pop = "opererade, cytostatikabehandlade HER2 positiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade, cytostatikabehandlade HER2+ invasiva fall utan fjärrmetastaser vid diagnos",
  target_values = c(90, 95),
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn ="Vid HER2-positiv invasiv bröstcancer rekommenderas behandling med antikroppsbehandling i kombination efter eller med cytostatika, under förutsättning att patienten kan tolerera det sistnämnda.",
  vid_tolkning = "Både preoperativ och postoperativ antikropps- och cytostatikabehandling är medtaget i beräkningen.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc32_def$sjhkod_var) %>%
  mutate(
    # Går på det som finns, pre eller postop. Om det ena saknas antas samma som finns för det andra.
    outcome = as.logical(pmax(post_antikropp_Värde, pre_antikropp_Värde, na.rm = TRUE)),

    d_kemo = as.logical(pmax(post_kemo_Värde, pre_kemo_Värde, na.rm = TRUE))
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Endast cytostatikabehandlade
    d_kemo == TRUE,

    # HER2+ (amplifiering eller 3+).
    d_her2_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc32_def$code,
  path = output_path,
  outcomeTitle = nkbc32_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc32_def),
  description = compile_description(nkbc32_def, report_end_year),
  varOther = compile_varOther(nkbc32_def),
  targetValues = nkbc32_def$target_values
)
