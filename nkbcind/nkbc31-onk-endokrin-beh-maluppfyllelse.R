nkbc31_def <- list(
  code = "nkbc31",
  lab = "Endokrin behandling, måluppfyllelse",
  pop = "opererade östrogenreceptorpositiva invasiva fall utan fjärrmetastaser vid diagnos",
  pop_short = "opererade ER+ invasiva fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(x)
  },
  mutate_outcome = function(x, ...) {
    mutate(x)
  },
  target_values = c(85, 90),
  sjhkod_var = "d_onk_sjhkod",
  other_vars = "a_pat_alder",
  om_indikatorn =
    paste(
      "Endokrin behandling bör erbjudas till alla patienter med östrogenreceptorpositiv (ER+) bröstcancer.",
      "För patienter med mycket låg risk för återfall (tumör <=10 mm av luminal A-typ utan spridning till lymfkörtlarna) kan man avstå från endokrin behandling förutsatt att patienten är informerad om balansen mellan risk och nytta.",
      "I de fall där samsjuklighet föreligger får nyttan med endokrin behandling avvägas med hänsyn till övriga medicinska faktorer."
    ),
  vid_tolkning =
    c(
      "Både preoperativ och postoperativ endokrin behandling är medtaget i beräkningen.",
      paste(
        "Här presenteras data för påbörjad behandling.",
        "Det finns studier som visar att ca 70% av patienterna stoppar eller gör längre avbrott i sin endokrinabehandling i huvudsak p.g.a. biverkningar."
      )
    ),
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)

filter_nkbc31_pop <- nkbc31_def$filter_pop
mutate_nkbc31_outcome <- nkbc31_def$mutate_outcome
