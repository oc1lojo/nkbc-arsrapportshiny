nkbc23 <- list(
  code = "nkbc23",
  lab = "Operation till strålbehandling",
  pop = "primärt opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Reg av given onkologisk behandling
      period >= 2012,

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
      outcome = as.numeric(ymd(post_rt_dat) - ymd(op_kir_dat)),
      outcome = ifelse(outcome < 0, 0, outcome)
    )
  },
  prop_within_value = 42,
  target_values = 80,
  sjhkod_var = "post_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Standardiserat vårdförlopp infördes 2016 för att säkra utredning och vård till patienter i rimlig och säker tid.",
  vid_tolkning = "Operationsdatum är datum för första operation, det innebär att tiden från sista operation till start av strålbehandling kan vara kortare än det som redovisas.",
  inkl_beskr_onk_beh = TRUE,
  teknisk_beskrivning = NULL
)
class(nkbc23) <- "nkbcind"

filter_nkbc23_pop <- nkbc23$filter_pop
mutate_nkbc23_outcome <- nkbc23$mutate_outcome
