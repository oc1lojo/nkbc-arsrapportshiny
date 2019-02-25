nkbc09e <- list(
  code = "nkbc09e",
  lab = "Spridning till lymfkörtlarna (klinisk) vid diagnos",
  lab_short = "Spridning till lymfkörtlarna",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(
      x
      # Endast invasiv cancer
      # invasiv == "Invasiv cancer", Bortselekterat pga om väljer enbart invasiv
      # cancer så tas alla med uppgift saknas på invasiv bort. Dock några fel? reg
      # in situ och N1 men men...
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = d_nstad
    )
  },
  sjhkod_var = "a_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Kännedom om tumörspridning till axillens lymfkörtlar ger vägledning för behandling och information om prognos. Grundas på bilddiagnostik och klinisk undersökning.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc09e) <- "nkbcind"

filter_nkbc09e_pop <- nkbc09e$filter_pop
mutate_nkbc09e_outcome <- nkbc09e$mutate_outcome
