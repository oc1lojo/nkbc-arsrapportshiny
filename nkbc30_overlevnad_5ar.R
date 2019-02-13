dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc30_def$sjhkod_var) %>%
  filter(!is.na(region)) %>%
  filter_nkbc30_pop() %>%
  mutate_nkbc30_outcome() %>%
  filter(
    # 5 års överlevnad så krävs 5 års uppföljning
    period <= report_end_year - 5
  ) %>%
  select(
    landsting, region, period, outcome, # OBS Ej sjukhus
    one_of(nkbc30_def$other_vars)
  )

rccShiny(
  data = dftemp,
  folder = nkbc30_def$code,
  path = output_path,
  outcomeTitle = nkbc30_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc30_def),
  description = compile_description(nkbc30_def, report_end_year),
  varOther = compile_varOther(nkbc30_def),
  targetValues = nkbc30_def$target_values
)
