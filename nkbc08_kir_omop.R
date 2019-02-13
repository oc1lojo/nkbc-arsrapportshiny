dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc08_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = ifelse(op_kir_sekbrost_Värde %in% c(0, 1), op_kir_sekbrost_Värde, NA),

    outcome = as.logical(!outcome)
  ) %>%
  filter(
    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc08_def$code,
  path = output_path,
  outcomeTitle = nkbc08_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc08_def),
  description = compile_description(nkbc08_def, report_end_year),
  varOther = compile_varOther(nkbc08_def),
  targetValues = nkbc08_def$target_values
)
