dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc29_def$sjhkod_var) %>%
  mutate(
    outcome = as.logical(post_rt_Värde)
  ) %>%
  filter(
    # Reg av given onkologisk behandling
    period >= 2012,

    # ett år bakåt då info från onk behandling blanketter
    period <= report_end_year - 1,

    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    # Endast mastektomi och subkutan mastektomi
    op_kir_brost_Värde %in% c(2, 4),

    # Spridning till lymfkörtlar
    op_pad_lglmetant > 0,

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_pn)

rccShiny(
  data = dftemp,
  folder = nkbc29_def$code,
  path = output_path,
  outcomeTitle = nkbc29_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc29_def),
  description = compile_description(nkbc29_def, report_end_year),
  varOther = compile_varOther(nkbc29_def),
  targetValues = nkbc29_def$target_values
)
