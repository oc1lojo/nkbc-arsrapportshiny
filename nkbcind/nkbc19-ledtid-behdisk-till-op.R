nkbc19_def <- list(
  code = "nkbc19",
  lab = "Första behandlingsdiskussion till operation",
  pop = "primärt opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  prop_within_value = 14,
  target_values = c(75, 90),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc19_pop <- nkbc19_def$filter_pop
mutate_nkbc19_outcome <- nkbc19_def$mutate_outcome
