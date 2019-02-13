dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc30_def$sjhkod_var) %>%
  mutate(
    lastdate = ymd(paste0(report_end_year, "-12-31")),
    surv_time = ymd(VITALSTATUSDATUM_ESTIMAT) - ymd(a_diag_dat),
    outcome = surv_time >= 365.25 * 5
  ) %>%
  filter(
    # 5 års överlevnad så krävs 5 års uppföljning
    period <= report_end_year - 5,

    !is.na(region)
  ) %>%
  select(landsting, region, period, outcome, a_pat_alder, d_invasiv, d_subtyp)

rccShiny(
  data = dftemp,
  folder = nkbc30_def$code,
  path = output_path,
  outcomeTitle = nkbc30_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc30_def),
  description = compile_description(nkbc30_def, report_end_year),
  varOther = compile_varOther(nkbc30_def),
  targetValues = nkbc30_def$target_values
)
