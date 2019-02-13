dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc10_def$sjhkod_var) %>%
  mutate(
    d_op_nhgok = op_pad_nhg_Värde %in% c(1, 2, 3),
    d_op_erok = op_pad_er_Värde %in% c(1, 2) | !is.na(op_pad_erproc),
    d_op_prok = op_pad_pr_Värde %in% c(1, 2) | !is.na(op_pad_prproc),
    d_op_herok = op_pad_her2_Värde %in% c(1, 2, 3) | op_pad_her2ish_Värde %in% c(1, 2),
    # Ki67 tillkom som nationell variabel 2014
    d_op_ki67ok = (op_pad_ki67_Värde %in% c(1, 2, 3) | !is.na(op_pad_ki67proc)) | period <= 2013,

    outcome = d_op_nhgok & d_op_erok & d_op_prok & d_op_herok & d_op_ki67ok
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Endast primär opereration (planerad om utförd ej finns)
    d_prim_beh_Värde == 1,

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc10_def$code,
  path = output_path,
  outcomeTitle = nkbc10_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc10_def),
  description = compile_description(nkbc10_def, report_end_year),
  varOther = compile_varOther(nkbc10_def),
  targetValues = nkbc10_def$target_values
)
