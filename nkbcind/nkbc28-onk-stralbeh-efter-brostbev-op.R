nkbc28_def <- list(
  code = "nkbc28",
  lab = "Strålbehandling efter bröstbevarande operation",
  pop = "invasiva fall med bröstbevarande operation utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(90, 95),
  sjhkod_var = "post_inr_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn =
    paste(
      "Strålbehandling efter bröstbevarande operation minskar risk för återfall.",
      "I de fall där samsjuklighet föreligger får nyttan med strålbehandling avvägas med hänsyn till övriga medicinska faktorer."
    ),
  vid_tolkning = NULL,
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc28_pop <- nkbc28_def$filter_pop
mutate_nkbc28_outcome <- nkbc28_def$mutate_outcome
