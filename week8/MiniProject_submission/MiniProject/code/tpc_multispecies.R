# =============================================================================
# author: "Anaga Ambady"
# tpc_multispecies.R  —  Three-species TPC comparison
# Direct curve labels, no legend, x-axis origin at 0
# =============================================================================
library(dplyr)
library(readr)
library(ggplot2)
library(ggtext)

rmax_data <- read_csv("results/model_averaged_rmax_by_temp.csv") %>%
  filter(r_max_avg > 0, !is.na(Temp), !is.na(Species))

# --- Define targets ----------------------------------------------------------
targets <- c(
  "Arthrobacter aurescens",
  "Acinetobacter.clacoaceticus..RDA.R.",
  "Pseudomonas.fluorescens.2"
)

colours <- c(
  "Arthrobacter aurescens"              = "#0072B2",
  "Acinetobacter.clacoaceticus..RDA.R." = "#D55E00",
  "Pseudomonas.fluorescens.2"           = "#009E73"
)

# --- Fit TPC for each species -------------------------------------------------
all_preds <- list()
all_pts   <- list()
label_df  <- data.frame()

for (i in seq_along(targets)) {
  sp <- targets[i]
  df <- rmax_data %>%
    filter(Species == sp) %>%
    mutate(log_rmax = log(r_max_avg))
  
  fit  <- lm(log_rmax ~ Temp + I(Temp^2), data = df)
  b1   <- coef(fit)["Temp"]
  b2   <- coef(fit)["I(Temp^2)"]
  Topt <- unname(-b1 / (2 * b2))
  R2   <- summary(fit)$r.squared
  
  nd      <- data.frame(Temp = seq(min(df$Temp), max(df$Temp), length.out = 300))
  nd$fit  <- predict(fit, newdata = nd)
  nd$Species <- sp
  all_preds[[i]] <- nd
  
  pts <- df %>%
    group_by(Temp) %>%
    summarise(med_log = median(log_rmax), .groups = "drop") %>%
    mutate(Species = sp)
  all_pts[[i]] <- pts
  
  # Label positioned at curve end (max Temp) for each species
  label_df <- bind_rows(label_df, data.frame(
    Species  = sp,
    Topt     = Topt,
    R2       = R2,
    x_label  = max(df$Temp),
    y_label  = nd$fit[which.max(nd$Temp)]
  ))
}

preds_all <- bind_rows(all_preds)
pts_all   <- bind_rows(all_pts)

# --- Build annotation labels -------------------------------------------------
# Stagger y positions slightly for Acinetobacter & Pseudomonas which overlap
label_df <- label_df %>%
  mutate(
    display = case_when(
      Species == "Arthrobacter aurescens"              ~ "A. aurescens",
      Species == "Acinetobacter.clacoaceticus..RDA.R." ~ "A. calcoaceticus",
      Species == "Pseudomonas.fluorescens.2"           ~ "P. fluorescens 2"
    ),
    topt_label = paste0("T[opt]==", round(Topt, 1), "*degree*C"),
    # nudge the two warm-species labels apart vertically
    y_nudge = case_when(
      Species == "Acinetobacter.clacoaceticus..RDA.R." ~  0.35,
      Species == "Pseudomonas.fluorescens.2"           ~ -0.35,
      TRUE                                             ~  0.0
    )
  )

# --- Plot --------------------------------------------------------------------
p_multi <- ggplot() +
  geom_line(data = preds_all,
            aes(x = Temp, y = fit, colour = Species),
            linewidth = 1.3) +
  geom_point(data = pts_all,
             aes(x = Temp, y = med_log, colour = Species),
             size = 3) +
  # Direct species + T_opt labels at right end of each curve
  geom_richtext(data = label_df,
                aes(x      = x_label + 0.8,
                    y      = y_label + y_nudge,
                    label  = paste0("*", display, "*  T<sub>opt</sub> = ",
                                    round(Topt, 1), "°C"),
                    colour = Species),
                hjust = 0, size = 3.5,
                fill = NA, label.color = NA)+  # transparent background/border 
  scale_colour_manual(values = colours, guide = "none") +
  # x-axis: start at 0, breaks at observed temps
  scale_x_continuous(
    limits = c(0, 45),                     
    breaks = seq(0, 40, by = 5),           
    expand = expansion(mult = c(0, 0))     
  ) +
  
  labs(
    title    = "Thermal Performance Curves — Species Comparison",
    subtitle = "Quadratic fit on log scale  |  Points = per-temperature medians",
    x        = "Temperature (°C)",
    y        = expression(paste("log(", r[max], ")  (log h"^-1, ")"))
  ) +
  theme_bw(base_size = 13) +
  theme(
    plot.title       = element_text(face = "bold", size = 13),
    plot.subtitle    = element_text(size = 9.5, colour = "grey40"),
    panel.grid.major = element_blank(),
    panel.grid.minor = element_blank(),
    legend.position  = "none"
  )

ggsave("results/plot_tpc_multispecies.png", p_multi,
       width = 9, height = 5.5, dpi = 300)
cat("Saved: results/plot_tpc_multispecies.png\n")