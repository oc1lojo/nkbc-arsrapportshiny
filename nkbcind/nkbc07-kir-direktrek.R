nkbc07_def <- list(
  code = "nkbc07",
  lab = "Omedelbara rekonstruktioner vid mastektomi",
  pop = "fall med mastektomi eller subkutan mastektomi utan fjärrmetastaser vid diagnos",
  pop_short = "mastektomerade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(15, 20),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Omedelbar rekonstruktion innebär att en bröstform återskapas i samband med att ett helt bröst opereras bort. Bröstrekonstruktion kan göras senare efter avslutad onkologisk behandling.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc07_pop <- nkbc07_def$filter_pop
mutate_nkbc07_outcome <- nkbc07_def$mutate_outcome
