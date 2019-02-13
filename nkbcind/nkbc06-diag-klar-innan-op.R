nkbc06_def <- list(
  code = "nkbc06",
  lab = "Fastställd diagnos innan operation",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(80, 90),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "En fastställd diagnos innan behandlingsstart är viktigt för planering och genomförande av behandling och undvikande av omoperationer.",
  vid_tolkning =
    paste(
      "Det kan ibland vara nödvändigt att operera patienten innan diagnosen är fastställd för att undvika alltför långa utredningstider.",
      "Fastställd diagnos måste vägas mot tidsåtgång."
    ),
  teknisk_beskrivning = NULL
)

filter_nkbc06_pop <- nkbc06_def$filter_pop
mutate_nkbc06_outcome <- nkbc06_def$mutate_outcome
