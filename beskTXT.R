str_sep_description <- "</br>\n</br>\n"

MisstCa <- "Datum för välgrundad misstanke om cancer tillkom som variabel 2016 och innan detta har datum för 1:a kontakt använts."

onkRed <- paste(
  "Uppgifter som rör given onkologisk behandling redovisas enbart t.o.m.",
  YEAR - 1, "p.g.a. eftersläpning i rapporteringen."
)

ettFallBrost <- paste(
  "Ett fall per bröst kan rapporterats till det nationella kvalitetsregistret för bröstcancer.",
  "Det innebär att samma person kan finnas med i statistiken upp till två gånger."
)

SKAS <- "Skövde och Lidköpings sjukhus presenteras tillsammans som Skaraborg."

sjhRed <- function() {
  paste0("Uppgifterna redovisas uppdelat på ", sjhTXT(GLOBALS$SJHKODUSE), ".")
}

sjhTXT <- function(SJHKODUSE = GLOBALS$SJHKODUSE) {
  if (SJHKODUSE == "a_inr_sjhkod") {
    sjhTXT <- "anmälande sjukhus"
  }
  else if (SJHKODUSE %in% c("post_inr_sjhkod", "pre_inr_sjhkod", "d_onk_sjhkod")) {
    sjhTXT <- "onkologiskt sjukhus"
  }
  else if (SJHKODUSE == "op_inr_sjhkod") {
    sjhTXT <- "opererande sjukhus"
  }
  else if (SJHKODUSE %in% c("d_onkpreans_sjhkod", "d_onkpostans_sjhkod")) {
    sjhTXT <- "rapporterande onkologiskt sjukhus och om detta saknas sjukhus ansvarigt för rapportering av onkologisk behandling, onkologiskt sjukhus, anmälande sjukhus"
  }
  return(sjhTXT)
}

# Default beskrivning
descTekBes <- function() {
  paste(
    paste("Population:", GLOBALS$POP),
    sjhRed(),
    sep = str_sep_description
  )
}

descTolk <- paste(
  ettFallBrost,
  SKAS,
  sep = str_sep_description
)

descTarg <- function() {
  if (length(GLOBALS$TARGET) == 1) {
    paste0("Målnivå: ", GLOBALS$TARGET[1], "%")
  } else if (length(GLOBALS$TARGET) == 2) paste0("Målnivåer: ", GLOBALS$TARGET[1], "% (låg) ", GLOBALS$TARGET[2], "% (hög)")
}

# define lab and pop
defGlobals <- function(LAB, POP, SJHKODUSE, SHORTLAB = NULL, SHORTPOP = NULL, TARGET = NULL) {
  out <- list(
    LAB = LAB,
    POP = POP,
    SJHKODUSE = SJHKODUSE,
    SHORTLAB = ifelse(!is.null(SHORTLAB), SHORTLAB, LAB),
    SHORTPOP = paste0("Bland ", ifelse(!is.null(SHORTPOP), SHORTPOP, POP)),
    TARGET = TARGET
  )
  return(out)
}
