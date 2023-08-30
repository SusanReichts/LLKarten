## LLKarten

relevante Referenzen: 
- https://wiki.openstreetmap.org/wiki/Map_features
- https://joshuamccrain.com/tutorials/maps/streets_tutorial.html 



# Straßenkarten zur Visualisierung Linguistic Landscapes (mit OSM)

entstanden aus dem Linguistikseminar zu Linguistic Landscapes in Konstanz, Sommersemester 2023, bei dem 3 Sitzungen in die Arbeit mit R eingeführt haben. Dieser Teil bezieht sich hierbei auf die Erstellung von Straßenkarten mit OSM und dem Einbinden eigener Beobachtungen. 

Vorwissen: 
- Daten einlesen (Datensatz: lingland.csv)
- Packages installieren & laden
- Daten beschreiben (tidyverse, oberflächlich)
- ggplot2

Packages für dieses Projekt: 
tidyverse, sf, ggmap, osmdata, (plotly)

---

<img width="684" alt="Screenshot 2023-08-29 at 21 24 02" src="https://github.com/SusanReichts/LLKarten/assets/93623936/3345dc6b-15a8-4e25-beb9-9f9431884b2b">

---

Datensatz ist in den Projektordner geladen, alternativ direkt über github zu laden

lingland <- read_csv("lingland.csv") 

oder:

lingland <- read.csv("https://raw.githubusercontent.com/SusanReichts/LLKarten/main/lingland.csv?token=GHSAT0AAAAAACG52U6XUR3USZPTHX6GK6FAZHO7UIQ")

## Datensatz Linguistic Landscapes

Die Studierenden sind mit den gewählten Themenbereichen Multilingualismus/Sprachvariation, sowie Stadtdialog/Protest, eigenständig in die Feldforschung gegangen. Rahmenbedingungen waren das Beitragen von mindestens 15 Bildern, sowie anschließender Annotation nach gemeinsam erarbeiteten Kriterien. Die Bilder wurden über Padlet zusammengetragen (hier wurden Koordinaten hinterlegt) und nach einem Export und initialen Cleaning in einem geteilten Google Sheets Dokument annotiert. 

Die Datensammlung ist weder repräsentativ, noch für einen bestimmten Bereich als vollstädnig anzusehen -- Ziel der Sammlung war vielmehr das Ergründen der Forschungsmethoden, -vor, sowie -nachüberlegungen. Das Einarbeiten in R sollte einen zusätzlichen Einblick in Auswertungsmöglichkeiten geben. 

Der Datensatz enthält neben den Annotationen auch Koordinaten, welche ein einfaches Plotten ermöglichen: 

    ggplot() +
      geom_point(data = lingland,
          aes(x = long, 
              y = lat))
          
![image](https://github.com/SusanReichts/LLKarten/assets/93623936/f93927fb-6dfd-4bce-98f8-2c879a624e83)


Theoretisch lassen sich auch hier bereits einige Eindrücke zu den Daten gewinnen, beispielsweise über das Adaptieren der aes Bezüge: 

    ggplot() +
      geom_point(data = lingland,
          aes(x = long,
              y = lat,
              fill = Format),
          shape = 21,
          alpha = .4)

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/72eecfb0-03bc-4b0d-8289-ecc6ff085a0a)


Mit ein wenig mehr Input, kann man so relativ schnell eine komplexe Visualisierung erstellen. 

    ggplot() +
      geom_point(data = lingland,
          aes(x = long,
              y = lat,
              fill = Format),
          shape = 21,
          alpha = .7) +
      scale_fill_manual(values = c("#FFBE0B",
                                   "#FB5607",
                                   "#FF006E",
                                   "#8338EC",
                                   "#3A86FF")) +
      theme_classic() +
      labs(title = "Datenpunkte",
           subtitle = "Linguistic Landscapes, 2023",
           x = "Längengrad",
           y = "Breitengrad",
           caption = "Daten aus dem Seminar")

![Screenshot 2023-08-30 at 10 40 39](https://github.com/SusanReichts/LLKarten/assets/93623936/a8326d4e-8952-4b17-bd80-5e9e52ad2cda)


Was hier fehlt ist natürlich der Bezug zum Raum um eventuelle Gruppierungen/Cluster in Fragestellungen zu place/space einzuordnen. Hierzu haben wir uns im Kurs für das Nutzen von OSM entschieden, da sich hier die gewonnenen Kenntnisse zu ggplot anwenden lassen und die Studierenden relativ schnell eigene visuelle Ideen umsetzen können. OSM, Open Street Maps, ist eine crowdsourcing Initiative, bei der diverse Geodaten gebündelt und bereitgestellt werden - hier haben Studierende also zusätzlich noch einen Einblick gewinnen können, wie sie selbst beim Bereitstellen und Updaten offener Daten mitmachen können. 

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/0c29f7ea-13c6-4173-a517-ad2555a7f375)



Über die Objektabfrage (Cursor mit Fragezeichen) lassen sich Karteninhalte überprüfen - beispielsweise alle hinterlegten Informationen zur Alten Rheinbrücke. Sämtliche Karteninhalte, von Parks bis hin zu einzelnen Papierkörben, sind als Objekte hinterlegt. Die Herausforderung besteht also im ersten Schritt aus dem Zusammensammeln relevanter Raumdaten. Das haben wir für die Studierenden im Vorfeld übernommen und ist mit dem untenstehenden Code replizierbar. 

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/2b43ffa7-dd7b-4b76-af6f-13506d640ef0)


Karteninhalte lassen sich als Einzelobjekte aus OSM extrahieren und dann variabel zusammensetzen. Hierzu ist es wichtig die jeweiligen Referenzen zu kennen:

> key - obere Kategorie (Bsp. water)
> values - zugehörige untere Kategorien (Bsp. lake)


Um die Karte zu erstellen, werden sf Objekte, die aus bestimmten values innerhalb der gewählten keys bestehen, übereinander geschichtet (nach dem ggplot System, was "unten" liegt wird überdeckt). Für unsere Karte haben wir uns auf 5 Objektarten fokussiert: Wasser, Grünflächen, Gebäude, Straßen, und die Grenze. Ein 6. Objekt stellen dann die gesammelten Daten dar. 

![GIF](https://github.com/SusanReichts/LLKarten/assets/93623936/f10afe28-5afb-41aa-9e11-fed0300a0ac4)



## Kartenobjekte erstellen

(Packages laden, siehe oben)

### Straßen

Ein Objekt wird via overpass query innerhalb einer sogenannten bounding box erstellt. Die bounding box legt hierbei den geographischen Rahmen fest, hier: Konstanz. Aus OSM wird dann ein key festgelegt und die gewünschten values. Hier haben wir uns für drei Level von Straßen entschieden, welche je unterschiedlich in opacity und Dicke visualisiert werden können, von groß (Autobahn, Kraftfahrstraße) zu klein (Fußweg). Straßen aus dem ersten Level werden wie folgt zu einem Objekt zusammengestellt: 

    KN_Strasse1 <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "highway", 
                      value = c("motorway", 
                                "trunk", 
                                "primary", 
                                "motorway_link",
                                "primary_link", 
                                "motorway_junction")) %>% 
      osmdata_sf()

Das kann man dann schon visualisieren! Hierbei nutzt man geom_sf() und einer Spezifizierung der Objektart. Man unterscheidet zwischen Point, Line und Polygon (wobei es auch multi polygone gibt). Eine Straße ist hier also meist line, kann aber auch ein polygon sein (Ringverkehr). Da muss man sich ein wenig durchprobieren, weil nicht immer durchsichtig ist, als was die jeweiligen OSM Objekte hinterlegt wurden. Wichtig ist beim Code letztlich noch das Ausweisen der Koordinaten, insbesondere wenn man mit Straßen, Flüssen, Seen, etc. arbeitet, die auch außerhalb der bounding box definiert sind. coord_sf() hilft diese dann auf einen Bereich zu schneiden, den man visualisieren möchte. 

    ggplot() +
      geom_sf(data = KN_Strasse1$osm_lines, 
              inherit.aes = FALSE, 
              color = "grey3",
              linewidth = .5) +
      coord_sf(xlim = c(9.15, 9.221), 
               ylim = c(47.655, 47.694))

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/95d454d9-219a-4e69-8056-5c2e96226865)


Die weiteren Straßenlevel lassen sich wie folgt erstellen: 

    KN_Strasse2 <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "highway", 
                  value = c("secondary", "secondary_link", "mini_roundabout","bus_guideway",
                            "busway", "road", "tertiary", "tertiary_link","unclassified")) %>% 
      osmdata_sf()


    KN_Strasse3 <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "highway", 
                  value = c( "residential", "living_street",
                            "service", "pedestrian", "track", "cycleway", "footway", "path")) %>%
      osmdata_sf()


und alle weiteren Objekte ... 

### Brücke

    KN_Bruecke <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "man_made", 
                  value = c("bridge", "pier", "embankment")) %>% 
      osmdata_sf()

### Bahn

    KN_Bahn <- getbb("Konstanz") %>%
      opq() %>%
      add_osm_feature(key = "railway", 
                  value="rail") %>% 
      osmdata_sf()


### Wasser

    KN_Wasser <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "water", 
                  value = c("river", "lake", "canal", "pond","harbour")) %>% 
      osmdata_sf()

    KN_Wasser2 <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "natural", 
                  value = c("water")) %>% 
      osmdata_sf()

    KN_Wasserweg <- getbb("Konstanz")%>%
      opq() %>% 
      add_osm_feature(key = "waterway", 
                  value= c("river", "stream")) %>% 
      osmdata_sf()

### Insel Steigenberger

    KN_Insel <- getbb("Konstanz")%>%
      opq() %>% 
      add_osm_feature(key = "landuse", 
                  value= c("commercial")) %>% 
      osmdata_sf()


### Wald & grüne Flächen

    KN_park <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key="leisure",
                  value= c("park",
                           "pitch")) %>% 
      osmdata_sf()

    KN_gruen <- getbb("Konstanz") %>%
      opq() %>%
      add_osm_feature(key="landuse",
                  value= c("forest",
                           "meadow",
                           "vineyard",
                           "grass",
                           "village_green",
                           "recreation_ground")) %>% 
      osmdata_sf()


### Grenze

    KN_Grenze <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key = "admin_level",
                  value = 2) %>% 
      osmdata_sf()


### Gebäude

    KN_buildings <- getbb("Konstanz") %>% 
      opq() %>% 
      add_osm_feature(key="building") %>% 
      osmdata_sf()


Wenn man die Objekte aufruft, bekommt man einen Einblick in die hinterlegten Daten, bspw. erfahren wir, dass KN_buildings hauptsächlich aus Polygonen besteht, aber auch 28 Multipolygone enthält. Hier lohnt es sich dann beides kurz zu visualisieren um zu erfahren, welche Objekte hier inbegriffen sind und ob man sowohl die Polygone als auch Multipolygone im letzten Kartierungsschritt mit ausweisen muss. 

---

## Karte zusammensetzen

Beim Zusammensetzen der Karte kommt es nun noch auf die Reihenfolge der Objekte an - so sollte man also erst den Fluss und dann die Brücke notieren, damit die Brücke ÜBER dem Wasser liegt. Der fertige Code für die untenstehende Karte sieht wie folgt aus: 

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
               ylim = c(47.655, 47.667))

    Karte #ausführen

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/7c237b6e-aa99-4e15-9af2-5ca4e9d39b93)


### Zuletzt kann man dann die eigenen Datenpunkte hinzufügen. Das kann man natürlich auch mit anderen Koordinaten machen, bspw. als Geschenk um bestimmte Plätze hervorzuheben. 

    Karte + geom_point(data = lingland,
                   aes(x = long,
                       y = lat),
                   shape = 21,
                   fill = "mediumvioletred",
                   color = "black",
                   alpha = .7) +
      labs(x = "",
           y = "") +
      theme_bw()

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/6d987372-50b3-4043-82a3-71ed959179a2)



## Interaktive Karte mit Plotly

    library(plotly)

    tt_Karte <- Karte + geom_point(data = lingland,
                               aes(x = long,
                                   y = lat,
                                   text = paste("Text:", Bildbeschreibung)),
                               shape = 21,
                               fill = "mediumvioletred",
                               color = "black",
                               alpha = .7) +
                        labs(x = "",
                             y = "") +
                        theme_bw()

    tt_BB <- ggplotly(tt_Karte)
    tt_BB

![image](https://github.com/SusanReichts/LLKarten/assets/93623936/ce327748-4ec4-4eb5-98ee-e742609217b9)



---



    
---



