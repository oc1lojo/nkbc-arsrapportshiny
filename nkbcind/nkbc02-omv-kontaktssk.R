nkbc02_def <- list(
  code = "nkbc02",
  lab = "Patienten har erbjudits, i journalen dokumenterad, kontaktsjuksköterska",
  lab_short = "Kontaktsjuksköterska",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(80, 95),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Enligt den Nationella  Cancerstrategin (SOU 2009:11) ska alla cancerpatienter erbjudas en kontaktsjuksköterska.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc02_pop <- nkbc02_def$filter_pop
mutate_nkbc02_outcome <- nkbc02_def$mutate_outcome
