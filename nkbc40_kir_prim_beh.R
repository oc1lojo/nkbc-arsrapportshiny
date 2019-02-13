nkbc40_def <- list(
  code = "nkbc40",
  lab = "Typ av primär behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_subtyp", "d_nstad"),
  om_indikatorn =
    paste(
      "Preoperativ (neoadjuvant) onkologisk behandling är aktuellt när reduktion av primärtumören önskas inför kirurgi och/eller utvärdering av behandlingseffekten med tumören kvar är en fördel.",
      "Tumörstorlek, spridning till lymfkörtlarna liksom biologisk subtyp påverkar val av preoperativ behandling eller ej, liksom typ av preoperativ behandling."
    ),
  vid_tolkning = "För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation.",
  teknisk_beskrivning = NULL
)

dftemp <- dfmain %>%
  add_sjhdata(sjukhuskoder, nkbc40_def$sjhkod_var) %>%
  mutate(
    # Prim op eller preop onk beh
    outcome = factor(d_prim_beh_Värde,
      levels = c(1, 2),
      labels = c(
        "Primär operation",
        "Preoperativ onkologisk behandling"
      )
    )
  ) %>%
  filter(
    # Endast opererade
    !is.na(op_kir_dat),

    # Ej fjärrmetastaser vid diagnos
    !a_tnm_mklass_Värde %in% 10,

    !is.na(region)
  ) %>%
  select(landsting, region, sjukhus, period, outcome, a_pat_alder, d_nstad, d_subtyp)

rccShiny(
  data = dftemp,
  folder = nkbc40_def$code,
  path = output_path,
  outcomeTitle = nkbc40_def$lab,
  textBeforeSubtitle = compile_textBeforeSubtitle(nkbc40_def),
  description = compile_description(nkbc40_def, report_end_year),
  varOther = compile_varOther(nkbc40_def),
  targetValues = nkbc40_def$target_values
)
