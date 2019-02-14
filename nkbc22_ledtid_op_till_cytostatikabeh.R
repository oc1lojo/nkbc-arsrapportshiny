df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc22)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc22_pop() %>%
  mutate_nkbc22_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc22))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc22),
  path = output_path,
  outcomeTitle = lab(nkbc22),
  textBeforeSubtitle = textBeforeSubtitle(nkbc22),
  description = description(nkbc22, report_end_year),
  varOther = varOther(nkbc22),
  propWithinValue = prop_within_value(nkbc22),
  targetValues = target_values(nkbc22)
)
