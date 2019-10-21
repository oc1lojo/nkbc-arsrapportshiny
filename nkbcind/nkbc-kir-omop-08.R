nkbc08 <- list(
  code = "nkbc08",
  lab = "Enbart en operation (ingen omoperation p.g.a. tumördata) i bröst",
  lab_short = "Enbart en operation",
  pop = "opererade fall utan fjärrmetastaser vid diagnos",
  filter_pop = function(x, ...) {
    filter(
      x,
      # Ej fjärrmetastaser vid diagnos
      !a_tnm_mklass_Varde %in% 10
    )
  },
  mutate_outcome = function(x, ...) {
    mutate(x,
      # Hantera missing
      outcome = ifelse(op_kir_sekbrost_Varde %in% c(0, 1), op_kir_sekbrost_Varde, NA),

      outcome = as.logical(!outcome)
    )
  },
  target_values = c(80, 90),
  sjhkod_var = "op_inr_sjhkod",
  other_vars = c("a_pat_alder", "d_invasiv"),
  om_indikatorn = "Om det vid analys av den bortopererade vävnaden visar sig att tumörvävnad kan ha kvarlämnats blir patienten ofta rekommenderad en omoperation.",
  vid_tolkning = NULL,
  teknisk_beskrivning = NULL
)
class(nkbc08) <- "nkbcind"

filter_nkbc08_pop <- nkbc08$filter_pop
mutate_nkbc08_outcome <- nkbc08$mutate_outcome
