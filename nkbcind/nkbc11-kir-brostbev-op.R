nkbc11 <- list(
  code = "nkbc11",
  lab = "Bröstbevarande operation",
  pop = "primärt opererade fall med invasiv cancer <=30 mm eller ej invasiv cancer <=20 mm utan fjärrmetastaser vid diagnos",
  pop_short = "primärt opererade fall med små tumörer utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Extent infördes mitten av 2014
      year(a_diag_dat) >= 2015,

      # Endast primär opereration (planerad om utförd ej finns)
      d_prim_beh_Värde == 1,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10,

      # Exkludera fall som ej op i bröstet eller missing
      op_kir_brost_Värde %in% c(1, 2, 4),

      # Extent <= 30mm (invasiv) resp 20mm (in situ)
      (d_max_extent <= 30 & d_invasiv == "Invasiv cancer" |
        d_max_extent <= 20 & d_invasiv == "Enbart cancer in situ")
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = ifelse(op_kir_brost_Värde == 1, TRUE, FALSE)
    )
  },
  target_values = c(70, 80),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Ett bröstbevarande ingrepp och  strålbehandling är  standradingrepp  för majoriten av tidigt upptäckta bröstcancrar . Tumörens egenskaper, form och storlek på bröstet spelar roll för av av kirurgisk operationsmetod.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc11) <- "nkbcind"

filter_nkbc11_pop <- nkbc11$filter_pop
mutate_nkbc11_outcome <- nkbc11$mutate_outcome
