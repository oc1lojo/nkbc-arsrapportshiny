nkbc19_def <- list(
  code = "nkbc19",
  lab = "Första behandlingsdiskussion till operation",
  pop = "primärt opererade fall utan fjärrmetastaser vid diagnos",
  prop_within_value = 14,
  target_values = c(75, 90),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc19_def$sjhkod_var) %>%
  mutate(
    outcome = as.numeric(ymd(op_kir_dat) - ymd(a_planbeh_infopatdat)),

    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Endast primär opereration (planerad om utförd ej finns)
    d_prim_beh_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc19_def$code,
  path = output_path,
  outcomeTitle = nkbc19_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc19_def),
  description = compile_description(nkbc19_def, report_end_year),
  varOther = compile_varOther(nkbc19_def),
  propWithinValue = nkbc19_def$prop_within_value,
  targetValues = nkbc19_def$target_values
)
