nkbc42 <- list(
  code = "nkbc42",
  lab = "Bröstbevarande operation",
  pop = "opererade fall med bröstkirurgi (fall med enbart axillkirurgi exkluderade) utan fjärrmetastas vid diagnos",
  pop_short = "opererade fall med bröstkirurgi utan fjärrmetastas vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast opererade
      !is.na(op_kir_dat),

      # Exkludera enbart axillkirurgi eller missing
      op_kir_brost_Värde %in% c(1, 2, 4),

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = case_when(
        op_kir_brost_Värde %in% 1 ~ TRUE,
        op_kir_brost_Värde %in% c(2, 4) ~ FALSE,
        TRUE ~ NA
      )
    )
  },
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn =
    paste(
      "Bröstbevarande ingrepp i kombination med strålbehandling är standardingreppet för majoriten av tidigt upptäckta bröstcancrar.",
      "Bl.a. tumörens storlek och lokalisation liksom bröstet storlek spelar roll för av av kirurgisk operationsmetod."
    ),
  vid_tolkning = "Case-mix liksom lokala terapitraditioner, exempelvis andelen preoperativt onkologiskt behandlade, påverkar andelen bröstbevarande kirurgi.",
  teknisk_beskrivning = NULL
)
class(nkbc42) <- "nkbcind"

filter_nkbc42_pop <- nkbc42$filter_pop
mutate_nkbc42_outcome <- nkbc42$mutate_outcome
