clean_nkbc_data <- function(x, ...) {
  x <- x %>%
    mutate_at(vars(ends_with("_Värde")), as.integer) %>%
    mutate_at(vars(ends_with("sjhkod")), as.integer) %>%
    mutate_if(
      is.character,
      # städa fritext-variabler från specialtecken
      function(y) gsub("[[:space:]]", " ", y)
    )

  # Rensa operationsformulärdata om inte operationsdatum är satt
  x[is.na(x$op_kir_dat), tidyselect::vars_select(names(x), starts_with("op_"))] <- NA

  return(x)
}
