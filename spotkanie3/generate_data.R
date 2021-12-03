library(dplyr)
library(ggplot2)

set.seed(2)

generate_cmp <- function(x) rnorm(20, sample(5L:10, 1))
generate_cmp2 <- function(x) rnorm(20, sample(6L:11, 1))
generate_cmp3 <- function(x) rnorm(20, sample(6L:10, 1))

df <- lapply(list(generate_cmp, generate_cmp2, generate_cmp), function(ith_gen) {
    lapply(1L:50, function(ith_cmp) {
        ith_gen()
    }) %>%
        bind_cols() %>%
        mutate(gr = sample(LETTERS, 1))
}) %>%
    bind_rows() %>%
    setNames(c(paste0("cmp", 1L:50), "gr"))

write.csv(df, file = "./spotkanie3/data.csv", row.names = FALSE)
