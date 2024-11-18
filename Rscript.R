
# Development of a new tutorial
# Author: Amelia Young
# Date: 13/11/2024

# Data Visualisation: Concave Hulls and Hex Maps
# Quantifying species range and visualising the impact of the Australian 'Black Summer'

# Workflow ----
# 1 - Load in the data
# 2 - Filter the data to include observations of interest
# 3 - Prepare the data for plotting 
# 4 - Ploting concave hull maps and hex maps 
# 5 - Add figure captions and save within GitHub repository 


# Read in data ----
invertebrates <- read.csv("/Users/mimi/Ecology/Tutorial/Data/invertebrate.data.03.2023.csv")


# Load libraries ----
library(tidyverse) # # contains dplyr (data manipulation), ggplot2 (data visualisation) and other useful packages
library(cowplot)  # making effective plot grids
library(sf) # for working with spatial data (simple features)
library(concaveman) # for creating concave hulls
library(ozmaps) # for polygon maps
library(patchwork) # for arranging plots


unique(invertebrates$class) # 50 unique classes
unique(invertebrates$family) # 2174 unique families
nrow(invertebrates) # 340059 observations


# Overview of data: ----

# Identify species that have more than 4 observations 
more_than_4_obs <- invertebrates %>%
  group_by(scientific_name) %>%
  summarise(n_obs = n()) %>% 
  filter(n_obs > 4) %>% 
  pull(scientific_name)

# Subset species with more than 4 observations and appear on mainland Australia + Tasmania
inverts_subset <- invertebrates %>%
  filter(scientific_name %in% more_than_4_obs)

subset_mainland <- inverts_subset %>% 
  filter(latitude < -10, latitude >= -45, longitude >= 113, longitude <= 155) %>% 
  select(scientific_name:family, longitude, latitude)

# Nest occurrence data ----
inverts_nest <- subset_mainland %>% 
  nest(coords = c(longitude, latitude))

inverts_nest %>%
  print(n = 6)

inverts_nest %>% 
  pluck("coords", 1) %>%  # 1 refers to the first element of the list column
  print(n = 6)

# Subset a random species from each class 
set.seed(123)  # Set seed so we all get the same results
subset <- inverts_nest %>% 
  group_by(class) %>% 
  slice_sample(n = 1)

# Convert coordinates into sf object and compute concave hulls as list columns.
subset_concave <- subset %>%
  mutate(points_sf = map(.x = coords,
                         ~ st_as_sf(.x, coords = c("longitude", "latitude"),
                                    crs = 4326)), 
         concave_sf = map(points_sf,
                          ~ concaveman(.x)))

# Unnest the concave hull list column
subset_concave <- subset_concave %>% 
  select(scientific_name:family, concave_sf) %>% 
  unnest(cols = c(concave_sf)) %>% 
  ungroup() %>%
  st_sf(crs = 4326) 

# Retrieve Australia polygon ----
aus <- st_transform(ozmap_country, 4326)

# Plotting spatial distributions ----
(inverts_concave <- ggplot() + 
  geom_sf(data = aus, colour = "black", fill = NA) +
  geom_sf(data = subset_concave, fill = "#E06E53", alpha = 0.2, lwd = 0) +
  coord_sf(xlim = c(110, 155)) +
  ggtitle("Spatial Distributions of Invertebrates Across Australia") + 
  theme_void())


# Save the ggplot object as an image
ggsave("Figures/aus_concave_hull.png", plot = inverts_concave, width = 8, height = 6, dpi = 300)




# Subsetting for just earthworms! ----

(worm_concave <- ggplot() + 
   geom_sf(data = aus, colour = "black", fill = NA) +
   geom_sf(data = subset_concave %>% filter(family == "Megascolecidae"), 
           fill = "#E06E53", alpha = 0.2, lwd = 0) +
   coord_sf(xlim = c(110, 155)) +
   ggtitle("Spatial Distributions of Earthworms Across Australia") + 
   theme_void())

# Save the ggplot object as an image
ggsave("Figures/earthworms.png", plot = worm_concave, width = 8, height = 6, dpi = 300)


# Subsetting for just sea spiders! ----

(spider_concave <- ggplot() + 
   geom_sf(data = aus, colour = "black", fill = NA) +
   geom_sf(data = subset_concave %>% filter(family == "Callipallenidae"), 
           fill = "#E06E53", alpha = 0.2, lwd = 0) +
   coord_sf(xlim = c(110, 155)) +
   ggtitle("Spatial Distributions of Sea Spiders Across Australia") + 
   theme_void())

# Save the ggplot object as an image
ggsave("Figures/spiders.png", plot = spider_concave, width = 8, height = 6, dpi = 300)


# NOW WE'VE EXPLORED THE GEOGRAPHICAL RANGE OF SOME INVERTEBRATES LET'S INVESTIGATE HOW THEY WERE
# AFFECTED BY THE 2019/2020 WILDFIRES VIA A HEX MAP:
# FIRE INVESTIGATION: ----

grid_all <- st_make_grid(aus, 
                         cellsize = 1, 
                         what = "polygons", 
                         square = FALSE,
                         flat_topped = TRUE)

ggplot() +
  geom_sf(data = grid_all)

# extract rows that are within AUS land
keep_hexes <- st_intersects(grid_all, aus) %>%
  as.data.frame(.) %>%
  pull(row.id)

# filter full grid to only hexagon IDs in AUS
oz_grid <- grid_all[keep_hexes]

(blank_aus_hex <- ggplot() + geom_sf(data = oz_grid))

# Save the ggplot object as an image
ggsave("Figures/blank_aus_hex.png", plot = blank_aus_hex, width = 8, height = 6, dpi = 300)


# Filter all invertebrates observed in 2018, 2019 and 2020, separately
# we cant use subset_mainland as it doesnt have a year column!

inverts_2018 <- invertebrates %>% filter(longitude < 155,
                                   longitude > 110,
                                   latitude > -45,
                                   latitude < -10, year == 2018)

inverts_2019 <- invertebrates %>% filter(longitude < 155,
                                         longitude > 110,
                                         latitude > -45,
                                         latitude < -10, year == 2019)

inverts_2020 <- invertebrates %>% filter(longitude < 155,
                                         longitude > 110,
                                         latitude > -45,
                                         latitude < -10, year == 2020)


# but how many observations are in each hexagon?

inverts_2018_sf <- inverts_2018 %>% 
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(4326))

intersect_2018 <- st_intersects(inverts_2018_sf, oz_grid)

inverts_2019_sf <- inverts_2019 %>% 
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(4326))

intersect_2019 <- st_intersects(inverts_2019_sf, oz_grid)

inverts_2020_sf <- inverts_2020 %>% 
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(4326))

intersect_2020 <- st_intersects(inverts_2020_sf, oz_grid)


# using tibbles ----
# condense counts into tibble
counts_2018 <- as_tibble(table(unlist(intersect_2018)), 
                    .name_repair = "unique") %>%
  rename("hex_id" = 1,
         "count" = 2) %>%
  mutate(hex_id = as.integer(hex_id)) %>%
  replace_na(list(count = 0))

# condense counts into tibble
counts_2019 <- as_tibble(table(unlist(intersect_2019)), 
                         .name_repair = "unique") %>%
  rename("hex_id" = 1,
         "count" = 2) %>%
  mutate(hex_id = as.integer(hex_id)) %>%
  replace_na(list(count = 0))

# condense counts into tibble
counts_2020 <- as_tibble(table(unlist(intersect_2020)), 
                         .name_repair = "unique") %>%
  rename("hex_id" = 1,
         "count" = 2) %>%
  mutate(hex_id = as.integer(hex_id)) %>%
  replace_na(list(count = 0))



oz_grid_2018 <- oz_grid %>%
  as_tibble() %>%
  mutate(id = row_number()) %>%
  full_join(counts_2018,
            by = join_by(id == hex_id)) %>%
  st_as_sf()

head(oz_grid_2018)

oz_grid_2019 <- oz_grid %>%
  as_tibble() %>%
  mutate(id = row_number()) %>%
  full_join(counts_2019,
            by = join_by(id == hex_id)) %>%
  st_as_sf()

head(oz_grid_2019)

oz_grid_2020 <- oz_grid %>%
  as_tibble() %>%
  mutate(id = row_number()) %>%
  full_join(counts_2020,
            by = join_by(id == hex_id)) %>%
  st_as_sf()

head(oz_grid_2020)

# PLOTTING: ----

(plot_2018 <- ggplot() +
  geom_sf(data = oz_grid_2018, aes(fill = count), size = .01) +
  scale_fill_gradientn(colours = c("#EEECEA", "#E06E53"), 
                       na.value = "white", 
                       trans = "log10",
                       labels = scales::comma_format(),
                       n.breaks = 6,
                       guide = guide_colourbar(title = "Observations")) +
  coord_sf(ylim = c(-45, -10), 
           xlim = c(110, 155)) +
  theme_void())

(plot_2019 <- ggplot() +
    geom_sf(data = oz_grid_2019, aes(fill = count), size = .01) +
    scale_fill_gradientn(colours = c("#EEECEA", "#E06E53"), 
                         na.value = "white", 
                         trans = "log10",
                         labels = scales::comma_format(),
                         n.breaks = 6,
                         guide = guide_colourbar(title = "Observations")) +
    coord_sf(ylim = c(-45, -10), 
             xlim = c(110, 155)) +
    theme_void())

(plot_2020 <- ggplot() +
    geom_sf(data = oz_grid_2020, aes(fill = count), size = .01) +
    scale_fill_gradientn(colours = c("#EEECEA", "#E06E53"), 
                         na.value = "white", 
                         trans = "log10",
                         labels = scales::comma_format(),
                         n.breaks = 6,
                         guide = guide_colourbar(title = "Observations")) +
    coord_sf(ylim = c(-45, -10), 
             xlim = c(110, 155)) +
    theme_void())


# Combine the plots in a row
(combined_plot <- plot_2018 + plot_2019 + plot_2020 + 
  plot_layout(ncol = 3, guides = "collect") +
  plot_annotation(title = "Comparison of Australian Invertebrate Abundance Across Years (2018–2020)"))

# Save the combined plot as an image
ggsave("Figures/combined_plot.png", plot = combined_plot, width = 18, height = 6, dpi = 300)





# Challenge Yourself! ----

# Filter all invertebrates observed in 1996 and 2010, separately
# we cant use subset_mainland as it doesn't have a year column!

inverts_1996 <- invertebrates %>% filter(longitude < 155,
                                         longitude > 110,
                                         latitude > -45,
                                         latitude < -10, year == 1996)

inverts_2010 <- invertebrates %>% filter(longitude < 155,
                                         longitude > 110,
                                         latitude > -45,
                                         latitude < -10, year == 2010)



# but how many observations are in each hexagon?

inverts_1996_sf <- inverts_1996 %>% 
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(4326))

intersect_1996 <- st_intersects(inverts_1996_sf, oz_grid)

inverts_2010_sf <- inverts_2010 %>% 
  st_as_sf(coords = c("longitude", "latitude"), 
           crs = st_crs(4326))

intersect_2010 <- st_intersects(inverts_2010_sf, oz_grid)



# condense counts into tibble
counts_1996 <- as_tibble(table(unlist(intersect_1996)), 
                         .name_repair = "unique") %>%
  rename("hex_id" = 1,
         "count" = 2) %>%
  mutate(hex_id = as.integer(hex_id)) %>%
  replace_na(list(count = 0))

# condense counts into tibble
counts_2010 <- as_tibble(table(unlist(intersect_2010)), 
                         .name_repair = "unique") %>%
  rename("hex_id" = 1,
         "count" = 2) %>%
  mutate(hex_id = as.integer(hex_id)) %>%
  replace_na(list(count = 0))




oz_grid_1996 <- oz_grid %>%
  as_tibble() %>%
  mutate(id = row_number()) %>%
  full_join(counts_1996,
            by = join_by(id == hex_id)) %>%
  st_as_sf()

head(oz_grid_1996)

oz_grid_2010 <- oz_grid %>%
  as_tibble() %>%
  mutate(id = row_number()) %>%
  full_join(counts_2010,
            by = join_by(id == hex_id)) %>%
  st_as_sf()

head(oz_grid_2010)


# PLOTTING: ----

(plot_1996 <- ggplot() +
   geom_sf(data = oz_grid_1996, aes(fill = count), size = .01) +
   scale_fill_gradientn(colours = c("#EEECEA", "#E06E53"), 
                        na.value = "white", 
                        trans = "log10",
                        labels = scales::comma_format(),
                        n.breaks = 6,
                        guide = guide_colourbar(title = "Observations")) +
   coord_sf(ylim = c(-45, -10), 
            xlim = c(110, 155)) +
   theme_void())

(plot_2010 <- ggplot() +
    geom_sf(data = oz_grid_2010, aes(fill = count), size = .01) +
    scale_fill_gradientn(colours = c("#EEECEA", "#E06E53"), 
                         na.value = "white", 
                         trans = "log10",
                         labels = scales::comma_format(),
                         n.breaks = 6,
                         guide = guide_colourbar(title = "Observations")) +
    coord_sf(ylim = c(-45, -10), 
             xlim = c(110, 155)) +
    theme_void())


# Combine the plots in a row
(combined_plot_challenge <- plot_1996 + plot_2010 + 
  plot_layout(ncol = 2, guides = "collect") +
    plot_annotation(title = "Comparison of Australian Invertebrate Abundance Between 1996 and 2010"))



# Save the combined plot as an image
ggsave("Figures/combined_plot_challenge.png", plot = combined_plot_challenge, width = 18, height = 6, dpi = 300)


