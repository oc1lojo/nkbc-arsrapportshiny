nkbc19 <- list(
  code = "nkbc19",
  lab = "Första behandlingsdiskussion till operation",
  pop = "primärt opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Endast opererade
      !is.na(op_kir_dat),

      # Endast primär opereration (planerad om utförd ej finns)
      d_prim_beh_Varde == 1,

      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      outcome = as.numeric(ymd(op_kir_dat) - ymd(a_planbeh_infopatdat)),

      outcome = ifelse(outcome < 0, 0, outcome)
    )
  },
  prop_within_value = 14,
  target_values = 80,
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc19) <- "nkbcind"

filter_nkbc19_pop <- nkbc19$filter_pop
mutate_nkbc19_outcome <- nkbc19$mutate_outcome
