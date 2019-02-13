nkbc39_def <- list(
  code = "nkbc39",
  lab = "Patienten ingår i studie",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    paste(
      "Ett övergripande mål är att erbjuda alla bröstcancerpatienter medverkan i studier för att utveckla nya behandlingar och arbetssätt.",
      "Indikatorn gäller alla typer av studier (t.ex. kliniska studier, omvårdnadsstudier, fysioterapi-studier).",
      "Indikatorn infördes 2017 och bör tolkas med försiktighet (regionala skillnader och underrapportering)."
    ),
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc39_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    a_beh_studie = as.logical(ifelse(a_beh_studie_Värde %in% c(0, 1), a_beh_studie_Värde, NA)),
    pre_beh_studie = as.logical(ifelse(pre_beh_studie_Värde %in% c(0, 1), pre_beh_studie_Värde, NA)),
    post_beh_studie = as.logical(ifelse(post_beh_studie_Värde %in% c(0, 1), post_beh_studie_Värde, NA)),
    # Beräkna indikator
    outcome =
      case_when(
        a_beh_studie | pre_beh_studie | post_beh_studie ~ TRUE,
        !a_beh_studie | !pre_beh_studie | !post_beh_studie ~ FALSE
      )
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
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc39_def$code,
  path = output_path,
  outcomeTitle = nkbc39_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc39_def),
  description = compile_description(nkbc39_def, report_end_year),
  varOther = compile_varOther(nkbc39_def),
  targetValues = nkbc39_def$target_values
)
