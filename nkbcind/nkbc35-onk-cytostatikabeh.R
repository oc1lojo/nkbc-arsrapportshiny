nkbc35_def <- list(
  code = "nkbc35",
  lab = "Cytostatikabehandling",
  pop = "opererade, invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  sjhkod_var = "d_onk_sjhkod",
  other_vars = c("a_pat_alder", "d_tstad", "d_nstad", "d_er"),
  om_indikatorn = "Pre- eller postoperativ cytostatikabehandling rekommenderas i allmänhet vid bröstcancer med spridning till axillens lymfkörtlar, men även utan lymfkörtelengagemang om tumören har svag hormonell känslighet och/eller då det föreligger riskfaktorer.",
  vid_tolkning =
    c(
      "Tumörstorlek och spridning till lymfkörtlar är kliniskt diagnostiserat.",
      "För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation."
    ),
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc35_pop <- nkbc35_def$filter_pop
mutate_nkbc35_outcome <- nkbc35_def$mutate_outcome
