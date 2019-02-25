df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc23)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc23_pop() %>%
  mutate_nkbc23_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc23))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc23),
  path = output_path,
  outcomeTitle = lab(nkbc23),
  textBeforeSubtitle = textBeforeSubtitle(nkbc23),
  description = description(nkbc23, report_end_year),
  varOther = varOther(nkbc23),
  propWithinValue = prop_within_value(nkbc23),
  targetValues = target_values(nkbc23)
)
