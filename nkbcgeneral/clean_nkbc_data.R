clean_nkbc_data <- function(x, ...) {
  x <- x %>%
    mutate_at(vars(ends_with("_Värde")), as.integer) %>%
    mutate_at(vars(ends_with("sjhkod")), as.integer) %>%
    mutate_if(
      is.character,
      # städa fritext-variabler från specialtecken
      function(y) gsub("[[:space:]]", " ", y)
    )

  return(x)
}
