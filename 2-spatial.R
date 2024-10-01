library(tidyverse)
# remotes::install_github("propertypricebn/bruneimap")
library(bruneimap)
library(ggrepel)
library(kernlab)
library(osrm)
library(osmdata)

# Load the data sets
soil_gps <- read_csv(
  "data/8389823/GPS - Revised.csv",
  # IMPORTANT!!! The csv file has latin1 encoding as opposed to UTF-8
  locale = readr::locale(encoding = "latin1")
)

soil_physico <- read_csv("data/8389823/Soil physicochemical properties.csv")
soil_texture <- read_csv("data/8389823/Soil texture classification.csv")

soil_gps <-
  soil_gps |>
  mutate(
    Latitude = as.numeric(sp::char2dms(Latitude, chd = "°")),
    Longitude = as.numeric(sp::char2dms(Longitude, chd = "°"))
  )


ggplot() +
  geom_sf(data = brn_sf) +
  geom_point(data = soil_gps, aes(Longitude, Latitude))

# Actually I just want to merge these two together
soil_df <- left_join(
  soil_physico,
  soil_texture,
  by = join_by(Habitat_type, Plot_name, Subplot_name, Soil_depth)
)

soil_df <- left_join(
  soil_df,
  soil_gps,
  by = join_by(Habitat_type, Plot_name)
)

ggplot() +
  geom_sf(data = kpg_sf) +
  geom_jitter(
    data = soil_df,
    aes(Longitude, Latitude, col = Nitrogen, size = Nitrogen,
        shape = Habitat_type),
    width = 0.001, height = 0.001, alpha = 0.7
  ) +
  scale_colour_viridis_c() +
  coord_sf(
    xlim = c(114.46, 114.54),
    ylim = c(4.58, 4.64)
  )

# line data ------------

brd <-
  read_sf("data/hotosm_brn_roads_lines_geojson/hotosm_brn_roads_lines_geojson.geojson") |>
  st_transform(4326)  # SET THE CRS!!! (WGS84)
glimpse(brd)

#e.g.
filter(brd, highway == "motorway")

brd_mjr <-
  brd |>
  filter(highway %in% c("motorway", "trunk", "primary", "secondary"))
brd_mjr

ggplot() +
  geom_sf(data = brn_sf) +
  geom_sf(data = brd_mjr, aes(col = highway), linewidth = 2) +
  # scale_colour_viridis_d(option = "turbo")
  ggsci::scale_colour_npg()

# Example of using osrm
ubd <- rev(c(4.9726109664120735, 114.89400927321438))
the_mall <- rev(c(4.905760317134548, 114.91674410868113))

library(osrm)
res <- osrmRoute(src = the_mall, dst = ubd)
view(res)

kpg_sf |>
  filter(district == "Brunei Muara",
         grepl("Gadong", mukim)) |>
  ggplot() +
  geom_sf() +
  geom_sf(data = res, col = "red3", linewidth = 1.2)  + # line data
  theme_bw()



ggplot() +
  geom_sf(data = kpg_sf)

ggplot(bn_pop_sf) +
  geom_sf(aes(fill = population)) +
  scale_fill_viridis_c(na.value = NA)

kpg_labels_sf <-
  bn_pop_sf |>
  arrange(desc(population)) |>
  slice_head(n = 10)

bn_pop_sf |>
  # filter(population > 50) |>
  ggplot() +
  geom_sf(aes(fill = population), col = NA, alpha = 0.8) +
  geom_sf(data = kpg_sf, fill = NA, col = "black") +
  ggrepel::geom_label_repel(
    data = kpg_labels_sf,
    aes(label = kampong, geometry = geometry),
    stat = "sf_coordinates",
    inherit.aes = FALSE,
    box.padding = 1,
    size = 2,
    max.overlaps = Inf
  ) +
  scale_fill_viridis_b(
    name = "Population",
    na.value = NA,
    labels = scales::comma,
    breaks = c(0, 100, 1000, 10000, 20000)
    # limits = c(0, 12000)
  ) +
  theme_bw()

q <-
  opq("brunei") |>
  add_osm_feature(
    key = "name",
    value = "Sekolah Rendah Datu Ratna Haji Muhammad Jaafar"
  ) |>
  osmdata_sf()

sr_kiarong <- q$osm_polygons

ggplot() +
  geom_sf(
    data = filter(kpg_sf, district == "Brunei Muara")
  ) +
  geom_sf(data = sr_kiarong, fill = "blue")


# Bounding box for Brunei Muara
bm_sf <- filter(kpg_sf, district == "Brunei Muara")
bm_bbox <- st_bbox(bm_sf)

q <-
  opq(bm_bbox) |>
  add_osm_feature(
    key = "amenity",
    value = "school"
  ) |>
  osmdata_sf()


schools_sf <-
  schools_sf |>
  select(osm_id, name) |>
  drop_na() |>
  st_centroid()  # CONVERT TO (x,y)


# ugly
ggplot() +
  geom_sf(data = schools_sf, fill = "red3", col = NA) +
  theme_bw()
f

# using centroids
ggplot() +
  geom_sf(data = bm_sf, aes(fill = mukim), alpha = 0.3) +
  geom_sf(data = schools_sf, col = "red3", size = 5)
