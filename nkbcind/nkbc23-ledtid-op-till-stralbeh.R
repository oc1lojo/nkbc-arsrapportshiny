nkbc23_def <- list(
  code = "nkbc23",
  lab = "Operation till strålbehandling",
  pop = "primärt opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  prop_within_value = 42,
  target_values = c(75, 90),
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
  vid_tolkning = "Operationsdatum är datum för första operation, det innebär att tiden från sista operation till start av cytostatikabehandling kan vara kortare än det som redovisas.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc23_pop <- nkbc23_def$filter_pop
mutate_nkbc23_outcome <- nkbc23_def$mutate_outcome
