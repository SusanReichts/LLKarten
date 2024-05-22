## Operatoren

# # für Kommentare vor, nach und zwischen Code Chunks
# <- für Objektzuweisungen ("besteht aus")
# %>% für Funktionsfolgen ("nimm und dann"), kommt aus dem magrittr Paket und ist Teil vom tidyverse (selbiges muss geladen sein)

## Code schreiben

#berechnet 1+1
1+1

#berechnet 1+1 und weist der Berechnung den Objektnamen 'a' zu
a <- 1+1 

#ruft das Objekt auf, Lösung wird als Output angezeigt
a 

#Objekte weiter bearbeiten
a <- a + 3
b <- a + 5

#Objekte in Beziehung stellen
c <- a + b
c

#bei kategorischen Werten die Anführungszeichen beachten!
item <- c("haus", "katze","seminar")
count <- c(4, 5, 7)

# kombinieren von 2 Vektoren zu einem dataframe
set <- data.frame(item, count) 
set

#Pakete laden
install.packages("tidyverse")
library(tidyverse)

#Wenn die Datei aus Github direkt in den R Projektordner heruntergeladen ist, dann kann man diese einfach wie folgt einlesen:
lingland <- read_csv("lingland.csv")

#Alternativ über die html: 

lingland <- read_csv("https://raw.githubusercontent.com/SusanReichts/LLKarten/main/lingland.csv")

#geladene Datei anzeigen
View(lingland) 

#Einblick in die Dimensionen
dim(lingland) 

#Einblick in die ersten 6 Beobachtungen
head(lingland)  

#Einblick in die Variablen/Vektoren
summary(lingland) 

#Einblick in die Variablen/Vektoren Namen
names(lingland) 

#Einblick in die Werte einer Variablen
lingland$Forschungsfokus 

##Daten betrachten

#Daten filtern
sample_Dialekt <- lingland %>% 
  filter(Zustand == "Geist")

sample_Dialekt

#Daten zusammenfassen
lingland %>% 
  summarise("Themen" = n_distinct(Forschungsfokus))

lingland %>% 
  summarise("Themen" = unique(Forschungsfokus))

#Daten gruppieren
lingland %>%  
  group_by(Forschungsfokus, 
           Format) %>% 
  summarise("Format" = unique(Format),
            n = n()) %>% 
  pivot_wider(names_from = Forschungsfokus,
              values_from = n) %>% 
  ungroup()

## Datenvisualisierung

#Balkendiagramm, basic
lingland %>% 
  ggplot(aes(x=Forschungsfokus))+
  geom_bar()

#Balkendiagramm, mit mehr Optionen
lingland %>% 
  ggplot(aes(x=Forschungsfokus))+
  geom_bar(fill="forestgreen", 
           color="black") +
  labs(title= "Unser erstes Balkendiagramm",
       subtitle= "Schaut her!",
       x= "Forschungsfokus",
       y="",
       caption="Daten aus dem Seminar 2023") +
  theme_bw()

#andere Plotbeispiele

#gestapeltes Balkendiagramm
#Kombination mit Filter um leere Formate rauszunehmen
#fill in aes() um zweite Kategorie hinzuzufügen

lingland %>% filter(Format !="NA") %>% 
  ggplot(aes(x=Forschungsfokus, 
             fill=Format)) + 
  geom_bar(position="fill", 
           colour="black") +
  theme_bw() +
  scale_fill_brewer() +
  labs(title="Format x Forschungsfokus",
       subtitle= "N=35",
       x="",
       y="rel. Anteil",
       caption="Linguistic Landscapes, 2023")

#Jitterplot, vol. 1
lingland %>% 
  ggplot(aes(x=Status, 
             y=Blick)) + 
  geom_jitter(alpha=.4,
              size=5, 
              shape=21,
              fill="red",
              width=.25,
              height=.25) +
  theme_classic() +
  labs(title="Status x Richtung",
       subtitle= "N=35",
       x="",
       y="",
       caption="Linguistic Landscapes, 2023")

#jitterplot, Vol. 2
lingland %>%
  ggplot(aes(x=Status,
             y=Sprachvariation)) +
  geom_jitter(alpha=.2,
              size=5,
              shape=21,
              fill="darkblue",
              width=.25,
              height=.25) +
  theme_classic(base_size = 12) +
  labs(title="Status x Sprachvariation",
       subtitle= "N=216",
       x="",
       y="",
       caption="Linguistic Landscapes, 2023")

#Bubbleplot
lingland %>% 
  group_by(Forschungsfokus, 
           Blick) %>% 
  summarise("Blick" = unique(Blick),
            n = n()) %>% 
  ungroup() %>% 
  ggplot(aes(x=Forschungsfokus, 
             y=Blick,
             size=n)) +
  geom_jitter(width=.25,
              height=.25,
              shape=21,
              fill="skyblue",
              color="transparent") +
  theme_bw() +
  labs(title="Verteilung Forschungsfokus",
       subtitle= "nach Positionierung",
       x="",
       y="",
       caption="Linguistic Landscapes, 2023") 

#gestapeltes Balkendiagramm, horizontal
lingland %>% subset(Status !="anerkannt" & Richtung =="bottom-up") %>% 
  ggplot(aes(x=Forschungsfokus)) + 
  geom_bar(aes(fill=Status),
           color="black") +
  coord_flip() +
  theme_bw(base_size=12) +
  scale_fill_brewer() +
  labs(title="Diskursarten (bottom-up)",
       x="",
       y="",
       caption="Linguistic Landscapes, 2023")


#Balkendiagramm mit FacetGrid
lingland %>%
  ggplot(aes(x = Forschungsfokus)) +
  geom_bar(color = "black", 
           fill = "pink") +
  labs(title = "Verteilung der Datenpunkte im Jahresverlauf",
       x = "Monate", 
       y = "Anzahl") +
  theme_bw()+
  facet_wrap(~Jahr) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
