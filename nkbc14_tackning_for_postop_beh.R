dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc14_def$sjhkod_var) %>%
  mutate(
    outcome = ifelse(!is.na(post_inr_dat) | !is.na(post_inr_enh) | !is.na(post_inr_initav), TRUE, FALSE)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc14_def$code,
  path = output_path,
  outcomeTitle = nkbc14_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc14_def),
  description = compile_description(nkbc14_def, report_end_year),
  varOther = compile_varOther(nkbc14_def),
  targetValues = nkbc14_def$target_values
)
