nkbc09a_def <- list(
  code = "nkbc09a",
  lab = "Kön vid diagnos",
  lab_short = "Kön",
  pop = "alla anmälda fall",
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Bröstcancer drabbar både män och kvinnor.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09a_def$sjhkod_var) %>%
  mutate(
    outcome = factor(KON_VALUE,
      levels = c(1, 2),
      labels = c("Män", "Kvinnor")
    )
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc09a_def$code,
  path = output_path,
  outcomeTitle = nkbc09a_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09a_def),
  description = compile_description(nkbc09a_def, report_end_year),
  varOther = compile_varOther(nkbc09a_def),
  targetValues = nkbc09a_def$target_values
)
