dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc28_def$sjhkod_var) %>%
  mutate(
    outcome = as.logical(post_rt_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Endast bröstbevarande operation
    op_kir_brost_Värde == 1,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc28_def$code,
  path = output_path,
  outcomeTitle = nkbc28_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc28_def),
  description = compile_description(nkbc28_def, report_end_year),
  varOther = compile_varOther(nkbc28_def),
  targetValues = nkbc28_def$target_values
)
