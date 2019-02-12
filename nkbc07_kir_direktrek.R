nkbc07_def <- list(
  code = "nkbc07",
  lab = "Omedelbara rekonstruktioner vid mastektomi",
  pop = "fall med mastektomi eller subkutan mastektomi utan fjärrmetastaser vid diagnos",
  pop_short = "mastektomerade fall utan fjärrmetastaser vid diagnos",
  target_values = c(15, 20),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Omedelbar rekonstruktion innebär att en bröstform återskapas i samband med att ett helt bröst opereras bort. Bröstrekonstruktion kan göras senare efter avslutad onkologisk behandling.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc07_def$sjhkod_var) %>%
  mutate(
    # Hantera missing
    outcome = as.logical(ifelse(op_kir_onkoplastik_Värde %in% c(0, 1), op_kir_onkoplastik_Värde, NA))
  ) %>%
  filter(
    # Endast mastektomi och subkutan mastektomi
    op_kir_brost_Värde %in% c(2, 4),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_invasiv)

rccShiny(
  data = dftemp,
  folder = nkbc07_def$code,
  path = output_path,
  outcomeTitle = nkbc07_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc07_def),
  description = compile_description(nkbc07_def, report_end_year),
  varOther = compile_varOther(nkbc07_def),
  targetValues = nkbc07_def$target_values
)

