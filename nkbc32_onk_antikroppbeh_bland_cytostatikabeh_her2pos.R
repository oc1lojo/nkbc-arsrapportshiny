df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc32)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc32_pop() %>%
  mutate_nkbc32_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc32))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc32),
  path = output_path,
  outcomeTitle = lab(nkbc32),
  textBeforeSubtitle = textBeforeSubtitle(nkbc32),
  description = description(nkbc32, report_end_year),
  varOther = varOther(nkbc32),
  targetValues = target_values(nkbc32)
)
