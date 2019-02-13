nkbc29_def <- list(
  code = "nkbc29",
  lab = "Strålbehandling efter mastektomi",
  pop = "invasiva fall med mastektomi, spridning till lymfkörtlarna och utan fjärrmetastaser vid diagnos",
  target_values = c(90, 95),
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_pn"),
  om_indikatorn =
    paste(
      "Då hela bröstet opererats bort (mastektomi) behövs oftast inte strålbehandling, lokoregional strålbehandling för patienter med endast mikrometastas rekommenderas inte.",
      "Vid spridning till lymfkörtlar bör strålbehandling ges både mot bröstkorgsväggen och lymfkörtlar."
    ),
  vid_tolkning = "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

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
