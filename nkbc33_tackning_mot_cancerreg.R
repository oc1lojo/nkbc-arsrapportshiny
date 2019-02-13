nkbc33_def <- list(
  code = "nkbc33",
  lab = "Täckningsgrad mot cancerregistret",
  pop = "alla anmälda fall",
  target_values = c(95, 99),
  sjhkod_var = "a_inr_sjhkod",
  om_indikatorn = "Anmälan till cancerregistret och anmälan till kvalitetsregistret är kombinerade och därmed undviks dubbelarbete.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- data.frame(
  region = c(
    rep(tackning_tbl$region, tackning_tbl$finns),
    rep(tackning_tbl$region, tackning_tbl$ejfinns)
  ),
  period = c(
    rep(tackning_tbl$ar, tackning_tbl$finns),
    rep(tackning_tbl$ar, tackning_tbl$ejfinns)
  ),
  outcome = c(
    rep(rep(TRUE, dim(tackning_tbl)[1]), tackning_tbl$finns),
    rep(rep(FALSE, dim(tackning_tbl)[1]), tackning_tbl$ejfinns)
  )
)

rccShiny(
  data = dftemp,
  folder = nkbc33_def$code,
  path = output_path,
  outcomeTitle = nkbc33_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc33_def),
  description = compile_description_nkbc33(nkbc33_def, report_end_year), # OBS: Specialfunktion
  varOther = compile_varOther(nkbc33_def),
  targetValues = nkbc33_def$target_values
)
