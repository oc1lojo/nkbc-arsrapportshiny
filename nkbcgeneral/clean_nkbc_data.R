clean_nkbc_data <- function(x, ...) {
  x %>%
    mutate_at(vars(ends_with("_Värde")), as.integer) %>%
    mutate_at(vars(ends_with("sjhkod")), as.integer)
}
