
library(dplyr)
library(ggdendro)
library(tidyr)
library(ggplot2)
library(grid)
library(gridExtra)

create_dend <- function(x, col_name1, col_name2) {
    pivot_wider(x, names_from = c(col_name2),
                values_from = "value") %>%
        as.data.frame() %>% {
            rownames(.) <- .[[col_name1]]
            .
        } %>%
        select(-1) %>%
        as.matrix() %>%
        dist() %>%
        hclust() %>%
        as.dendrogram()
}

get_legend <- function(gg_plot) {
    grob_table <- ggplotGrob(gg_plot)
    grob_table[["grobs"]][[which(sapply(grob_table[["grobs"]], function(x) x[["name"]]) == "guide-box")]]
}

arrange_dendrogram <- function(heatmap,
                               dendrogram_top,
                               dendrogram_right,
                               top_right = NULL,
                               widths = c(0.8, 0.2),
                               heights = c(0.2, 0.8)) {

    grob_list <- list(heatmap = ggplotGrob(heatmap),
                      dendrogram_top = ggplotGrob(dendrogram_top),
                      dendrogram_right = ggplotGrob(dendrogram_right))

    if(is.null(top_right))
        top_right <- grid.rect(gp = gpar(col = NA), draw = FALSE)

    max_width <- unit.pmax(grob_list[["heatmap"]][["widths"]],
                           grob_list[["dendrogram_top"]][["widths"]])

    grob_list[["heatmap"]][["widths"]] <-
        grob_list[["dendrogram_top"]][["widths"]] <-
        max_width

    max_height <- unit.pmax(grob_list[["heatmap"]][["heights"]],
                            grob_list[["dendrogram_right"]][["heights"]])

    grob_list[["heatmap"]][["heights"]] <-
        grob_list[["dendrogram_right"]][["heights"]] <-
        max_height

    grid.arrange(grob_list[["dendrogram_top"]],
                 top_right,
                 grob_list[["heatmap"]],
                 grob_list[["dendrogram_right"]],
                 widths = widths, heights = heights)

}

plot_dendrogram <- function(dendro) {
    dendro %>%
        dendro_data %>%
        segment %>%
        ggplot(aes(x = x, y = y, xend = xend, yend = yend)) +
        geom_segment() +
        scale_y_continuous("") +
        scale_x_discrete("",
                         limits = factor(1L:nobs(dendro)),
                         labels = labels(dendro))
}


files <- list.files(path = "./data", pattern = "\\.csv$", full.names = TRUE)

ldf <- lapply(1:length(files), function(ith_file) {

    print(paste("Dane", ith_file))

    dat <- read.csv(files[ith_file])
    nm <- colnames(dat)

    dat_dend1 <- create_dend(dat, nm[1], nm[2])
    dat_dend2 <- create_dend(dat, nm[2], nm[1])

    dendro_top <- plot_dendrogram(dat_dend1)
    dendro_right <- plot_dendrogram(dat_dend2) + coord_flip()

    hm <- ggplot(dat, aes(dat[, 1], dat[, 2], z = dat[, 3], fill= as.factor(dat[, 3]))) +
        geom_tile(color="black") +
        scale_fill_discrete(name = nm[3]) +
        xlab(nm[1]) +
        ylab(nm[2])

    plt <- arrange_dendrogram(hm + theme_bw() + theme(legend.position = "bottom"),
                              dendro_top + theme_void(), dendro_right + theme_void())

    path <- paste0(substring(files[ith_file], first = 1, last = nchar(files[ith_file]) - 3), "png")
    ggsave(path, plt, device = "png", width = 10, height = 10)

})


print("Skrypt wykonany!")


