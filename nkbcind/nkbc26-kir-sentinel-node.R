nkbc26_def <- list(
  code = "nkbc26",
  lab = "Sentinel node operation",
  pop = "invasiva fall utan spridning till lymfkörtlar (klinisk diagnos) eller fjärrmetastaser vid diagnos",
  pop_short = "invasiva fall utan spridning till lymfkörtlar eller fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(90, 95),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn =
    paste(
      "Kännedom om tumörspridning till axillens lymfkörtlar vägleder behandlingsrekommendationer.",
      "Sentinelnodetekniken minskar risken för armbesvär då endast ett fåtal (1–4) körtlar tas bort."
    ),
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)

filter_nkbc26_pop <- nkbc26_def$filter_pop
mutate_nkbc26_outcome <- nkbc26_def$mutate_outcome
