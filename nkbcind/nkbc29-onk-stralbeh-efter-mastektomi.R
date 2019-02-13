nkbc29_def <- list(
  code = "nkbc29",
  lab = "Strålbehandling efter mastektomi",
  pop = "invasiva fall med mastektomi, spridning till lymfkörtlarna och utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      year(a_diag_dat) >= 2012,

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Endast mastektomi och subkutan mastektomi
      op_kir_brost_Värde %in% c(2, 4),

      # Spridning till lymfkörtlar
      op_pad_lglmetant > 0,

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
  other_vars = c("a_pat_alder", "d_pn"),
  om_indikatorn =
    paste(
      "Då hela bröstet opererats bort (mastektomi) behövs oftast inte strålbehandling, lokoregional strålbehandling för patienter med endast mikrometastas rekommenderas inte.",
      "Vid spridning till lymfkörtlar bör strålbehandling ges både mot bröstkorgsväggen och lymfkörtlar."
    ),
  vid_tolkning = "Spridning till lymfkörtlar är definerat som metastas > 0.2 mm i axillen.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc29_pop <- nkbc29_def$filter_pop
mutate_nkbc29_outcome <- nkbc29_def$mutate_outcome
