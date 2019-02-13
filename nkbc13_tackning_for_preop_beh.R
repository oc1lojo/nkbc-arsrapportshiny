dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc13_def$sjhkod_var) %>%
  mutate(
    outcome = ifelse(!is.na(pre_inr_dat) | !is.na(pre_inr_enh) | !is.na(pre_inr_initav), TRUE, FALSE)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast opererade
    !is.na(op_kir_dat),

    # Endast preoponk behandling (planerad om utförd ej finns)
    d_prim_beh_Värde == 2,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc13_def$code,
  path = output_path,
  outcomeTitle = nkbc13_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc13_def),
  description = compile_description(nkbc13_def, report_end_year),
  varOther = compile_varOther(nkbc13_def),
  targetValues = nkbc13_def$target_values
)
