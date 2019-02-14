nkbc28 <- list(
  code = "nkbc28",
  lab = "Strålbehandling efter bröstbevarande operation",
  pop = "invasiva fall med bröstbevarande operation utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      year(a_diag_dat) >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Endast bröstbevarande operation
      op_kir_brost_Värde == 1,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = as.logical(post_rt_Värde)
    )
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
class(nkbc28) <- "nkbcind"

filter_nkbc28_pop <- nkbc28$filter_pop
mutate_nkbc28_outcome <- nkbc28$mutate_outcome
