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

#Wenn die Datei aus ILIAS in den Projektordner geladen ist, dann kann man die einlesen:
lingland <- read_csv("LingLand.csv")

#Alternativ über Environment - Import Dataset - zum Download Ordner navigieren

#Wichtig! Die Datei selbst ist anders geschrieben als das Objekt mit dem wir arbeiten
#Umbenennung geht easy über Objektzuweisung (neuer Name vor den Pfeil, alter Name dahinter)

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
  filter(Regionaldialekt == "Schwäbisch")

sample_Dialekt

#Daten zusammenfassen
lingland %>% 
  summarise("Dialekte" = n_distinct(Regionaldialekt))

lingland %>% 
  summarise("Dialekte" = unique(Regionaldialekt))

#Daten gruppieren
lingland %>%  
  group_by(Status) %>% 
  summarise("Status" = unique(Status),
            "durchschnittliche Sprachvariation" = mean(`Sprachvariation N`)) %>% 
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
       subtitle= "N=216",
       x="",
       y="rel. Anteil",
       caption="Linguistic Landscapes, 2023")

#Jitterplot, vol. 1
lingland %>% 
  ggplot(aes(x=Status, 
             y=Richtung)) + 
  geom_jitter(alpha=.4,
              size=5, 
              shape=21,
              fill="red",
              width=.25,
              height=.25) +
  theme_classic() +
  labs(title="Status x Richtung",
       subtitle= "N=216",
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
  ggplot(aes(x=Forschungsfokus, 
             y=Format,
             size=`Sprachvariation N`)) +
  geom_jitter(alpha=.4,
              width=.25,
              height=.25,
              shape=21,
              fill="purple",
              color="transparent") +
  theme_bw() +
  labs(title="Format x Forschungsfokus",
       subtitle= "nach Anzahl der Sprachvarietäten",
       x="",
       y="",
       caption="Linguistic Landscapes, 2023")

#gestapeltes Balkendiagramm, horizontal
lingland %>% subset(Status !="anerkannt" & Diskurs!= "NA" & Richtung =="bottom-up") %>% 
  ggplot(aes(x=Diskurs)) + 
  geom_bar(aes(fill=Status),
           color="black") +
  coord_flip() +
  theme_bw(base_size=12) +
  scale_fill_brewer() +
  labs(title="Diskursfunktionen (bottom-up)",
       x="",
       y="",
       caption="Linguistic Landscapes, 2023")


#gestapeltes Balkendiagramm mit angepasster Legende
lingland %>% ggplot(aes(x=`Sprachvariation N`)) +
  geom_bar(aes(fill=`Sprache - deutsch`),
           color= "black") +
  theme_classic(base_size = 12) +
  labs(title="Sprachvariation in dokumentierten Zeichen",
       fill= "Sprachvariation",
       x="Anzahl enthaltener Sprachvarietäten",
       y="",
       caption="Linguistic Landscapes, 2023") +
  scale_fill_discrete(labels=c('inkl. deutsch', 'kein deutsch'))

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

#Beitrag
lingland %>% 
  ggplot(aes(x=Person)) +
  geom_bar(position="fill",
           aes(fill=Forschungsfokus),
           color="black") +
  coord_flip() +
  scale_fill_brewer(palette=2) +
  theme_bw() +
  labs(title = "Beitrag und Verteilung Fokus",
       x = "Anteil", 
       y = "Beitragende")



