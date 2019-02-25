df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc39)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc39_pop() %>%
  mutate_nkbc39_outcome() %>%
  filter(
    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1
  ) %>%
  select(
    outcome, period, region, landsting, sjukhus,
    one_of(other_vars(nkbc39))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc39),
  path = output_path,
  outcomeTitle = lab(nkbc39),
  textBeforeSubtitle = textBeforeSubtitle(nkbc39),
  description = description(nkbc39, report_end_year),
  varOther = varOther(nkbc39),
  targetValues = target_values(nkbc39)
)
