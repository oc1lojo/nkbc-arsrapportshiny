nkbc05 <- list(
  code = "nkbc05",
  lab = "Multidisciplinär konferens efter operation",
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
      outcome = as.logical(ifelse(op_mdk_Värde %in% c(0, 1), op_mdk_Värde, NA))
    )
  },
  target_values = c(90, 99),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Att definierade specialister och professioner deltar i MDK och formulerar behandlingsrekommendationer har betydelse för vårdprocess för jämlik vård, kunskapsstyrd vård och för kvalitetssäkring.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc05) <- "nkbcind"

filter_nkbc05_pop <- nkbc05$filter_pop
mutate_nkbc05_outcome <- nkbc05$mutate_outcome
