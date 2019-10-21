nkbc47 <- list(
  code = "nkbc47",
  lab = "Preoperativ onkologisk behandling",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast opererade
      !is.na(op_kir_dat),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Preop onk beh
      outcome = case_when(
        d_prim_beh_Varde %in% 2 ~ TRUE,
        d_prim_beh_Varde %in% 1 ~ FALSE,
        TRUE ~ NA
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
class(nkbc47) <- "nkbcind"

filter_nkbc47_pop <- nkbc47$filter_pop
mutate_nkbc47_outcome <- nkbc47$mutate_outcome
