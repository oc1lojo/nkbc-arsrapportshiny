df_tmp <- df_main %>%
  add_sjhdata(sjukhuskoder, sjhkod_var(nkbc30)) %>%
  filter(!is.na(region)) %>%
  filter_nkbc30_pop() %>%
  mutate_nkbc30_outcome() %>%
  filter(
    # 5 års överlevnad så krävs 5 års uppföljning
    period <= report_end_year - 5
  ) %>%
  select(
    landsting, region, period, outcome, # OBS Ej sjukhus
    one_of(other_vars(nkbc30))
  )

rccShiny(
  data = df_tmp,
  folder = code(nkbc30),
  path = output_path,
  outcomeTitle = lab(nkbc30),
  textBeforeSubtitle = textBeforeSubtitle(nkbc30),
  description = description(nkbc30, report_end_year),
  varOther = varOther(nkbc30),
  targetValues = target_values(nkbc30)
)
