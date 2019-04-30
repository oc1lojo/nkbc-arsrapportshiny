nkbc45 <- list(
  code = "nkbc45",
  lab = "Typ av axillkirurgi",
  lab_short = "Axillkirurgi",
  pop = "opererade fall med axillingrepp och utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Opererade fall
      !is.na(op_kir_dat),

      # Axillingrepp
      op_kir_axill_Värde %in% 1,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = factor(
        if_else(op_kir_axilltyp_Värde %in% c(1, 2, 3), op_kir_axilltyp_Värde, 98L),
        levels = c(1, 3, 2, 98),
        labels = c("Enbart SN", "SN och utrymning", "Enbart utrymning", "Uppgift saknas")
      )
    )
  },
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv", "d_nstad"),
  om_indikatorn = "<mark>TBA</mark>",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc45) <- "nkbcind"

filter_nkbc45_pop <- nkbc45$filter_pop
mutate_nkbc45_outcome <- nkbc45$mutate_outcome
