nkbc09e_def <- list(
  code = "nkbc09e",
  lab = "Spridning till lymfkörtlarna (klinisk) vid diagnos",
  lab_short = "Spridning till lymfkörtlarna",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Kännedom om tumörspridning till axillens lymfkörtlar ger vägledning för behandling och information om prognos. Grundas på bilddiagnostik och klinisk undersökning.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc09e_pop <- nkbc09e_def$filter_pop
mutate_nkbc09e_outcome <- nkbc09e_def$mutate_outcome
