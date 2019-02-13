dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc05_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(op_mdk_Värde %in% c(0, 1), op_mdk_Värde, NA))
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc05_def$code,
  path = output_path,
  outcomeTitle = nkbc05_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc05_def),
  description = compile_description(nkbc05_def, report_end_year),
  varOther = compile_varOther(nkbc05_def),
  targetValues = nkbc05_def$target_values
)
