nkbc40 <- list(
  code = "nkbc40",
  lab = "Typ av primär behandling",
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
      # Prim op eller preop onk beh
      outcome = factor(d_prim_beh_Värde,
        levels = c(1, 2),
        labels = c(
          "Primär operation",
          "Preoperativ onkologisk behandling"
        )
      )
    )
  },
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_trigrp", "d_nstad"),
  om_indikatorn =
    paste(
      "Preoperativ (neoadjuvant) onkologisk behandling är aktuellt när reduktion av primärtumören önskas inför kirurgi och/eller utvärdering av behandlingseffekten med tumören kvar är en fördel.",
      "Tumörstorlek, spridning till lymfkörtlarna liksom biologisk subtyp påverkar val av preoperativ behandling eller ej, liksom typ av preoperativ behandling."
    ),
  vid_tolkning = "För fall med preoperativ onkologisk behandling är östrogenreceptoruttryck hämtat från nålsbiopsi innan behandling, i övriga fall från operation.",
  teknisk_beskrivning = NULL
)
class(nkbc40) <- "nkbcind"

filter_nkbc40_pop <- nkbc40$filter_pop
mutate_nkbc40_outcome <- nkbc40$mutate_outcome
