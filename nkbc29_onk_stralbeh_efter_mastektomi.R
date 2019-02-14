df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc29)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc29_pop() %>%
  mutate_nkbc29_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc29))
  )


rccShiny(
  data = df_tmp,
  folder = code(nkbc29),
  path = output_path,
  outcomeTitle = lab(nkbc29),
  textBeforeSubtitle = textBeforeSubtitle(nkbc29),
  description = description(nkbc29, report_end_year),
  varOther = varOther(nkbc29),
  targetValues = target_values(nkbc29)
)
