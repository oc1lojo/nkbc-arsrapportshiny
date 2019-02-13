nkbc32_def <- list(
  code = "nkbc32",
  lab = "Antikroppsbehandling bland cytostatikabehandlade",
  pop = "opererade, cytostatikabehandlade HER2 positiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade, cytostatikabehandlade HER2+ invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
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
