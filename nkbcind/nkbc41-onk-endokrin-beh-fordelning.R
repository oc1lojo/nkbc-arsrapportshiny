nkbc41_def <- list(
  code = "nkbc41",
  lab = "Endokrin behandling, pre- respektive postoperativt",
  pop = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn = "Den aktuella tabellen presenterar andelen fall som fått preoperativ respektive postoperativ endokrin behandling eller bägge.",
  vid_tolkning = "Här presenteras data för påbörjad behandling. Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak p.g.a. biverkningar.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc41_pop <- nkbc41_def$filter_pop
mutate_nkbc41_outcome <- nkbc41_def$mutate_outcome
