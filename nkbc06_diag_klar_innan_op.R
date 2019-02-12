nkbc06_def <- list(
  code = "nkbc06",
  lab = "Fastställd diagnos innan operation",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  target_values = c(80, 90),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "En fastställd diagnos innan behandlingsstart är viktigt för planering och genomförande av behandling och undvikande av omoperationer.",
  vid_tolkning =
    paste(
      "Det kan ibland vara nödvändigt att operera patienten innan diagnosen är fastställd för att undvika alltför långa utredningstider.",
      "Fastställd diagnos måste vägas mot tidsåtgång."
    ),
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc06_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(a_diag_preopmorf_Värde %in% c(0, 1), a_diag_preopmorf_Värde, NA))
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
  folder = nkbc06_def$code,
  path = output_path,
  outcomeTitle = nkbc06_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc06_def),
  description = compile_description(nkbc06_def, report_end_year),
  varOther = compile_varOther(nkbc06_def),
  targetValues = nkbc06_def$target_values
)
