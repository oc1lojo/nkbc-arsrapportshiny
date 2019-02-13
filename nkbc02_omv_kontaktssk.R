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
