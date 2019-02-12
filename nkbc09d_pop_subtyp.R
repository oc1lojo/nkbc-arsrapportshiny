nkbc09d_def <- list(
  code = "nkbc09d",
  lab = "Biologisk subtyp vid diagnos",
  lab_short = "Biologisk subtyp",
  pop = "invasiva fall",
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn =
    c(
      "Invasiv bröstcancer delas in i grupper, subtyper, enligt tumörens biologiska egenskaper, Luminal, HER2-positiv och trippelnegativ. De olika subtyperna är känsliga för olika behandlingar.",
      "Luminal – tumörer som uttrycker östrogenreceptorer (ER) och/eller progesteronreceptorer (PgR), det vill säga, är ER-positiva och/ eller PgR positiva.",
      "HER2-positiva – tumörer har många kopior av HER2-genen (amplifiering) vilket leder till en ökning av antalet HER2-receptorer på cellytan. Detta i sin tur stimulerar till snabb tillväxt.",
      "Trippelnegativ – tumörer saknar östrogenreceptorer (ER) och progesteronreceptorer (PgR) och överuttrycker inte HER2. Den är varken hormonkänslig eller känslig för behandling riktad mot HER2-receptorn."
    ),
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc09d_def$sjhkod_var) %>%
  mutate(
    outcome = d_subtyp
  ) %>%
  filter(
    # Endast invasiv cancer
    d_invasiv == "Invasiv cancer",

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder)

rccShiny(
  data = dftemp,
  folder = nkbc09d_def$code,
  path = output_path,
  outcomeTitle = nkbc09d_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc09d_def),
  description = compile_description(nkbc09d_def, report_end_year),
  varOther = compile_varOther(nkbc09d_def),
  targetValues = nkbc09d_def$target_values
)
