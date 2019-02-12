nkbc09c_def <- list(
  code = "nkbc09c",
  lab = "Invasivitet vid diagnos",
  lab_short = "Invasivitet",
  pop = "alla anmälda fall",
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Invasiv cancer innebär att cancercellerna infiltrerar i bröstkörtelns stödjevävnad och kan sprida sig via lymfsystemet eller blodbanan till andra organ. Cancer in situ (CIS),  ett förstadium till bröstcancer, innebär att cancercellerna ligger inuti bröstets utförsgångar och  körtlar. CIS kan inte spridas, det vill säga ge upphov till fjärrmetastaser.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09c_def$sjhkod_var) %>%
  mutate(
    outcome = d_invasiv
  ) %>%
  filter(
    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc09c_def$code,
  path = output_path,
  outcomeTitle = nkbc09c_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09c_def),
  description = compile_description(nkbc09c_def, report_end_year),
  varOther = compile_varOther(nkbc09c_def),
  targetValues = nkbc09c_def$target_values
)
