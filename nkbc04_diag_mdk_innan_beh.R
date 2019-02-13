dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc04_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_mdk_Värde %in% c(0, 1), a_mdk_Värde, NA))
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc04_def$code,
  path = output_path,
  outcomeTitle = nkbc04_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc04_def),
  description = compile_description(nkbc04_def, report_end_year),
  varOther = compile_varOther(nkbc04_def),
  targetValues = nkbc04_def$target_values
)
