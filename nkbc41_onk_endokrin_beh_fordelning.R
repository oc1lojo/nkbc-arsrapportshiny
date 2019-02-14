df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc41)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc41_pop() %>%
  mutate_nkbc41_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    landsting, region, sjukhus, period, outcome,
    one_of(other_vars(nkbc41))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc41),
  path = output_path,
  outcomeTitle = lab(nkbc41),
  textBeforeSubtitle = textBeforeSubtitle(nkbc41),
  description = description(nkbc41, report_end_year),
  varOther = varOther(nkbc41),
  targetValues = target_values(nkbc41)
)
