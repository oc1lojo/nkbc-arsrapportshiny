nkbc02_def <- list(
  code = "nkbc02",
  lab = "Patienten har erbjudits, i journalen dokumenterad, kontaktsjuksköterska",
  lab_short = "Kontaktsjuksköterska",
  pop = "alla anmälda fall",
  target_values = c(80, 95),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Enligt den Nationella  Cancerstrategin (SOU 2009:11) ska alla cancerpatienter erbjudas en kontaktsjuksköterska.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc02_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_omv_kssk_Värde %in% c(0, 1), a_omv_kssk_Värde, NA))
  ) %>%
  filter(
    # kontaktsjuksköterska tillkom mitten av 2014
    period >= 2015,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc02_def$code,
  path = output_path,
  outcomeTitle = nkbc02_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc02_def),
  description = compile_description(nkbc02_def, report_end_year),
  varOther = compile_varOther(nkbc02_def),
  targetValues = nkbc02_def$target_values
)
