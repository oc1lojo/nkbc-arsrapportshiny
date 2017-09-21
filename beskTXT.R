MisstCa <- "Datum för välgrundad misstanke om cancer tillkom som variabel 2016 och innan detta har datum för 1:a kontakt använts."

onkRed <- paste0("Uppgifter som rör given onkologisk behandling redovisas enbart tom ", YEAR - 1, " pga eftersläpning i rapporteringen.")

ettFallBrost <- "Ett fall per bröst kan rapporterats till det nationella kvalitetsregistret för bröstcancer. 
Det innebär att samma person kan finnas med i statistiken upp till två gånger."

SKAS <- "Skövde och Lidköpings sjukhus presenteras tillsammans som Skaraborg."

sjhRed <- function(){
  paste0("Uppgifterna redovisas uppdelat på ", sjhTXT(GLOBALS$SJHKODUSE),".")
}

sjhTXT <- function(SJHKODUSE = GLOBALS$SJHKODUSE){
  if (SJHKODUSE == "a_inr_sjhkod") {
    sjhTXT <- "anmälande sjukhus"
  }
  else if (SJHKODUSE == "a_onk_sjhkod") {
    sjhTXT <- "onkologiskt sjukhus"
  }
  else if (SJHKODUSE == "a_kir_sjhkod") {
    sjhTXT <- "opererande sjukhus"
  }
  else if (SJHKODUSE == "d_onkans_sjhkod") {
    sjhTXT <- "sjukhus ansvarigt för rapportering av onkologisk behandling. Om detta saknas används i första hand onkologiskt sjukhus och i andra hand anmälande sjukhus"
  }
  else if (SJHKODUSE == "d_uppfans_sjhkod") {
    sjhTXT <- "sjukhus ansvarigt för rapportering av uppföljning. Om detta saknas används i första hand onkologiskt sjukhus och i andra hand anmälande sjukhus"
  }
  return(sjhTXT)
}

# Default beskrivning
descTekBes <- function(){
  paste0(
    "Population: ", GLOBALS$POP,
    "<p></p>",
    sjhRed()
  )
}

descTolk <- paste0(
  ettFallBrost,
  "<p></p>",
  SKAS
)

descTarg <- function(){
    paste0(
      "<p></p>",
      paste0("Målnivåer: ", GLOBALS$TARGET[1], "% (låg) ", GLOBALS$TARGET[2], "% (hög)")
    )
}

# define lab and pop
defGlobals <- function(LAB, POP, SJHKODUSE, SHORTLAB = NULL, SHORTPOP = NULL, TARGET = NULL) {
  out <- list(LAB = LAB, 
              POP = POP, 
              SJHKODUSE = SJHKODUSE,
              SHORTLAB = ifelse(!is.null(SHORTLAB), SHORTLAB, LAB),
              SHORTPOP = paste0("Bland ",ifelse(!is.null(SHORTPOP), SHORTPOP, POP)), 
              TARGET = TARGET
  )
  return(out)
}
