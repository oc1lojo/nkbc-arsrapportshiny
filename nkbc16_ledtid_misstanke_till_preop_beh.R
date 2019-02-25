df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc16)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc16_pop() %>%
  mutate_nkbc16_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc16))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc16),
  path = output_path,
  outcomeTitle = lab(nkbc16),
  textBeforeSubtitle = textBeforeSubtitle(nkbc16),
  description = description(nkbc16, report_end_year),
  varOther = varOther(nkbc16),
  propWithinValue = prop_within_value(nkbc16),
  targetValues = target_values(nkbc16)
)
