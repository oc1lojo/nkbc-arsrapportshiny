nkbc32_def <- list(
  code = "nkbc32",
  lab = "Antikroppsbehandling bland cytostatikabehandlade",
  pop = "opererade, cytostatikabehandlade HER2 positiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade, cytostatikabehandlade HER2+ invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      period >= 2012,

      # Endast opererade
      !is.na(op_kir_dat),

      # Endast invasiv cancer
      d_invasiv == "Invasiv cancer",

      # Endast cytostatikabehandlade
      d_kemo == TRUE,

      # HER2+ (amplifiering eller 3+).
      d_her2_Värde == 1,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Värde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Går på det som finns, pre eller postop. Om det ena saknas antas samma som finns för det andra.
      outcome = as.logical(pmax(post_antikropp_Värde, pre_antikropp_Värde, na.rm = TRUE))
    )
  },
  target_values = c(90, 95),
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Vid HER2-positiv invasiv bröstcancer rekommenderas behandling med antikroppsbehandling i kombination efter eller med cytostatika, under förutsättning att patienten kan tolerera det sistnämnda.",
  vid_tolkning = "Både preoperativ och postoperativ antikropps- och cytostatikabehandling är medtaget i beräkningen.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc32_pop <- nkbc32_def$filter_pop
mutate_nkbc32_outcome <- nkbc32_def$mutate_outcome
