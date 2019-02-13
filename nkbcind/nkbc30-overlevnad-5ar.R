nkbc30_def <- list(
  code = "nkbc30",
  lab = "Observerad 5 års överlevnad",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = 88,
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv", "d_subtyp"),
  om_indikatorn =
    paste(
      "Total överlevnad betraktas som det viktigaste utfallsmåttet.",
      "Observerad överlevnad anger de bröstcancerfall som överlevt 5 år efter diagnos.",
      "Dödsorsakerna kan vara andra än bröstcancer."
    ),
  vid_tolkning = NULL,
  inkl_beskr_overlevnad_5ar = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc30_pop <- nkbc30_def$filter_pop
mutate_nkbc30_outcome <- nkbc30_def$mutate_outcome
