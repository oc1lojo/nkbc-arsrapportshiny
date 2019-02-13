dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc17_def$sjhkod_var) %>%
  mutate(
    d_a_diag_misscadat = ymd(coalesce(a_diag_misscadat, a_diag_kontdat)),
    outcome = as.numeric(ymd(a_diag_besdat) - d_a_diag_misscadat),

    outcome = ifelse(outcome < 0, 0, outcome)
  ) %>%
  filter(
    # Endast fall med år från 2013 (1:a kontakt tillkom 2013)
    period >= 2013,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc17_def$code,
  path = output_path,
  outcomeTitle = nkbc17_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc17_def),
  description = compile_description(nkbc17_def, report_end_year),
  varOther = compile_varOther(nkbc17_def),
  propWithinValue = nkbc17_def$prop_within_value,
  targetValues = nkbc17_def$target_values
)
