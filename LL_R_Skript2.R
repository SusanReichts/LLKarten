#packages laden

library(tidyverse)
library(sf)
library(ggmap)

#install.packages("osmdata") #nur beim ersten Mal
library(osmdata) #Open Street Map Daten laden



#unsere Daten als Scatterplot

lingland <- read_csv("https://raw.githubusercontent.com/SusanReichts/LLKarten/main/lingland.csv")

ggplot() +
  geom_point(data=lingland,
             aes(x=long,
                 y=lat),
             shape=21,
             color="black",
             alpha=.6)

#mit einer Kategorie farblich codiert

ggplot() +
  geom_point(data=lingland,
             aes(x=long,
                 y=lat,
                 fill=Forschungsfokus),
             shape=21,
             alpha=.4,
             size=3)

#mit eigenen Farben und weiteren stilistischen Elementen

ggplot() +
  geom_point(data=lingland,
             aes(x=long,
                 y=lat,
                 fill=Forschungsfokus),
             shape=21,
             alpha=.7,
             size=3) +
  scale_fill_manual(values=c("#FFBE0B",
                             "#FF006E",
                             "#8338EC",
                             "#3A86FF"))+
  theme_classic()+
  labs(title="Datenpunkte",
       subtitle="Linguistic Landscapes, 2023",
       x="Längengrad",
       y="Breitengrad",
       caption="Daten aus dem Seminar")



#Geo Daten und Objekterstellung 

##Objekte

#Um Objekte in einem bestimmten geografischen Bereich zu laden, lohnt es sich, die entsprechenden Rahmenkoordinaten (=bounding box) zu ermitteln. Hierzu in die untere linke einer Karte klicken und die Koordination herauskopieren, und dann das gleiche mit der oberen rechten Ecke. 

#linke Ecke: 47.657709, 9.154822
#rechte Ecke: 47.682067, 9.238846

#Die Koordinaten werden dann in die overpass query (opq) geladen - siehe unten.

#Straßen

KN_Strasse1 <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "highway", 
                  value = c("motorway", "trunk", "primary", "motorway_link",
                            "primary_link", "motorway_junction")) %>% 
  osmdata_sf()


KN_Strasse2 <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "highway", 
                  value = c("secondary", "secondary_link", "mini_roundabout","bus_guideway",
                            "busway", "road", "tertiary", "tertiary_link","unclassified")) %>% 
  osmdata_sf()


KN_Strasse3 <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "highway", 
                  value = c( "residential", "living_street",
                            "service", "pedestrian", "track", "cycleway", "footway", "path")) %>%
  osmdata_sf()

#Brücke

KN_Bruecke <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "man_made", 
                  value = c("bridge", "pier", "embankment")) %>% 
  osmdata_sf()

#Bahn

KN_Bahn <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "railway", 
                  value="rail") %>% 
  osmdata_sf()


#Wasser

KN_Wasser <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "water", 
                  value = c("river", "lake", "canal", "pond","harbour")) %>% 
  osmdata_sf()

KN_Wasser2 <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "natural", 
                  value = c("water")) %>% 
  osmdata_sf()

KN_Wasserweg <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "waterway", 
                  value= c("river", "stream")) %>% 
  osmdata_sf()

#Insel Steigenberger

KN_Insel <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "landuse", 
                  value= c("commercial")) %>% 
  osmdata_sf()


#Wald & grüne Flächen

KN_park <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key="leisure",
                  value= c("park",
                           "pitch")) %>% 
  osmdata_sf()

KN_gruen <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key="landuse",
                  value= c("forest",
                           "meadow",
                           "vineyard",
                           "grass",
                           "village_green",
                           "recreation_ground")) %>% 
  osmdata_sf()


#Grenze

KN_Grenze <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key = "admin_level",
                  value = 2) %>% 
  osmdata_sf()


#Gebäude

KN_buildings <- opq(c(9.15, 47.64, 9.24, 47.69)) %>% 
  add_osm_feature(key="building") %>% 
  osmdata_sf()

KN_buildings

#Karte zusammengebaut

Karte <- ggplot() +
  geom_sf(data=KN_park$osm_polygons,
          inherit.aes=FALSE,
          fill= "mediumaquamarine",
          color="NA") +
  geom_sf(data=KN_gruen$osm_polygons,
          inherit.aes=FALSE,
          fill= "mediumaquamarine",
          color="NA")+
  geom_sf(data=KN_park$osm_multipolygons,
          inherit.aes=FALSE,
          fill= "mediumaquamarine",
          color="NA") +
  geom_sf(data=KN_gruen$osm_multipolygons,
          inherit.aes=FALSE,
          fill= "mediumaquamarine",
          color="NA")+
  geom_sf(data=KN_Wasserweg$osm_lines, 
          inherit.aes = FALSE, 
          color = "skyblue2",
          size=.8) + 
  geom_sf(data=KN_Wasser$osm_multipolygons, 
          inherit.aes = FALSE, 
          fill = "skyblue2",
          color="skyblue2") + 
  geom_sf(data=KN_Wasser2$osm_polygons, 
          inherit.aes = FALSE, 
          fill = "skyblue2",
          color="skyblue2") + 
  geom_sf(data=KN_Insel$osm_polygons, 
          inherit.aes = FALSE, 
          fill = "white", 
          colour="NA")  +
  geom_sf(data=KN_buildings$osm_polygons,
          inherit.aes = FALSE,
          fill = "mistyrose3") +
  geom_sf(data=KN_Bruecke$osm_polygons, 
          inherit.aes=FALSE, 
          color=NA, 
          fill="white") +
  geom_sf(data = KN_Strasse1$osm_lines, 
          inherit.aes = FALSE, 
          color = "grey3",
          linewidth = .5) +
  geom_sf(data = KN_Strasse1$osm_polygons, 
          inherit.aes = FALSE, 
          color = "grey3",
          fill="grey3",
          linewidth = .5) +
  geom_sf(data = KN_Strasse2$osm_lines, 
          inherit.aes = FALSE, 
          color = "grey2",
          linewidth = .35) +
  geom_sf(data = KN_Strasse2$osm_polygons, 
          inherit.aes = FALSE, 
          color = "grey2",
          fill="grey2",
          linewidth = .35) +
  geom_sf(data = KN_Strasse3$osm_lines, 
          inherit.aes = FALSE, 
          color = "grey2",
          linewidth = .2) +
  geom_sf(data = KN_Strasse3$osm_polygons, 
          inherit.aes = FALSE, 
          color = "grey2",
          fill=NA,
          linewidth = .2)+ 
  geom_sf(data = KN_Bahn$osm_lines,
          inherit.aes = FALSE,
          color = "gray1",
          linewidth = .3, 
          linetype="longdash") +
  geom_sf(data= KN_Grenze$osm_lines,
          inherit.aes = FALSE,
          color= "deeppink2",
          linewidth = 1,
          alpha = .6,
          linetype="dotted") +
  coord_sf(xlim = c(9.168, 9.186), 
           ylim = c(47.655, 47.667)) +
  theme(panel.background = element_rect(fill = "#ffffff",
                                        color = "NA"))

Karte #ausführen


# Karte mit unseren Daten

Karte + geom_point(data=lingland,
                   aes(x=long,
                       y=lat),
                   shape=21,
                   fill="mediumvioletred",
                   color="black",
                   alpha=.7,
                   size=3) +
  labs(x="",
       y="") +
  theme_bw()
