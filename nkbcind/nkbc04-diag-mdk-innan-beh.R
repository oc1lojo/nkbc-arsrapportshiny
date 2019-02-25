nkbc04 <- list(
  code = "nkbc04",
  lab = "Multidisciplinär konferens inför behandlingstart",
  lab_short = "Kontaktsjuksköterska",
  pop = "alla anmälda fall",
  filter_pop = function(x, ...) {
    filter(x) # ingen filtrering
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      outcome = as.logical(ifelse(a_mdk_Värde %in% c(0, 1), a_mdk_Värde, NA))
    )
  },
  target_values = c(90, 99),
  sjhkod_var = "a_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Att definierade specialister och professioner deltar i MDK och formulerar behandlingsrekommendationer har betydelse för vårdprocess för jämlik vård, kunskapsstyrd vård och för kvalitetssäkring.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc04) <- "nkbcind"

filter_nkbc04_pop <- nkbc04$filter_pop
mutate_nkbc04_outcome <- nkbc04$mutate_outcome
