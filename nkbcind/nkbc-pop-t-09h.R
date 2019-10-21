nkbc09h <- list(
  code = "nkbc09h",
  lab = "Tumörstorlek vid operation",
  lab_short = "Tumörstorlek",
  pop = "primärt opererade invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Enbart primärt opererade
      !is.na(op_kir_dat),
      d_prim_beh_Värde %in% 1,

      # Enbart invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome1 = as.numeric(op_pad_invstl),
      outcome2 = cut(op_pad_invstl,
        breaks = c(-Inf, 20, 50, Inf),
        labels = c("<=20 mm", "20-50 mm", ">50 mm")
      )
    )
  },
  outcome = c("outcome1", "outcome2"),
  outcome_title = c("Tumörstorlek", "Tumörstorlek, kategorier"),
  prop_within_unit = "mm",
  prop_within_value = 20,
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_trigrp"),
  om_indikatorn = "Tumörstorlek baserad på mikroskopisk analys av preparat från primär operation, dvs operation utan föregående onkologisk behandling. Uppgiften om tumörstorlek ger prognostisk information inför val av postoperativ onkologisk behandling",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc09h) <- "nkbcind"

filter_nkbc09h_pop <- nkbc09h$filter_pop
mutate_nkbc09h_outcome <- nkbc09h$mutate_outcome
