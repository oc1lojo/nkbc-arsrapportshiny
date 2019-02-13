nkbc03_def <- list(
  code = "nkbc03",
  lab = "Individuell vårdplan (Min Vårdplan) har upprättats i samråd med patienten",
  lab_short = "Min vårdplan",
  pop = "alla anmälda fall",
  target_values = c(80, 95),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "En individuell skriftlig vårdplan, kallad Min vårdplan, ska tas fram för varje patient med cancer enligt den  Nationella Cancerstrategin (SOU 2009:11).",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc03_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_omv_indivplan_Värde %in% c(0, 1), a_omv_indivplan_Värde, NA))
  ) %>%
  filter(
    # min vp tillkom mitten av 2014
    period >= 2015,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc03_def$code,
  path = output_path,
  outcomeTitle = nkbc03_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc03_def),
  description = compile_description(nkbc03_def, report_end_year),
  varOther = compile_varOther(nkbc03_def),
  targetValues = nkbc03_def$target_values
)
