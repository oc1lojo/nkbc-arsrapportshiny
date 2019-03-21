nkbc09h <- list(
  code = "nkbc09h",
  lab = "Tumörstorlek",
  pop = "opererade invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Enbart opererade
      !is.na(op_kir_dat),

      # Enbart invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = op_pad_invstl
    )
  },
  prop_within_unit = "mm",
  prop_within_value = 20,
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_prim_beh_op"),
  om_indikatorn = "<mark>TBA</mark>",
  vid_tolkning =
    c(
      "<mark>I populationen ingår både primärt opererade och opererade efter påbörjad/genomförd preoperativ onkologisk behandling.</mark>"
    ),
  teknisk_beskrivning = NULL
)
class(nkbc09h) <- "nkbcind"

filter_nkbc09h_pop <- nkbc09h$filter_pop
mutate_nkbc09h_outcome <- nkbc09h$mutate_outcome
