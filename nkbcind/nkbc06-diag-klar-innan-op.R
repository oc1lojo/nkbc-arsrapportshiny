nkbc06 <- list(
  code = "nkbc06",
  lab = "Fastställd diagnos innan operation",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      outcome = as.logical(ifelse(a_diag_preopmorf_Värde %in% c(0, 1), a_diag_preopmorf_Värde, NA))
    )
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
class(nkbc06) = "nkbcind"

filter_nkbc06_pop <- nkbc06$filter_pop
mutate_nkbc06_outcome <- nkbc06$mutate_outcome
