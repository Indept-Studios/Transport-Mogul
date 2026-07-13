# Transport Mogul
## Game Design Document (GDD)
### Version 0.1 (Current MVP)

---

# 1. Spielübersicht

## 1.1 Arbeitstitel
Transport Mogul

## 1.2 Genre
Wirtschafts-/Management-Spiel (2D, minimalistisch)

## 1.3 Kernidee
Der Spieler leitet ein kleines Transportunternehmen.

Er nimmt Aufträge an, schickt Fahrzeuge auf zeitbasierte Missionen und verdient Geld sowie Ruf.  
Mit steigendem Ruf werden lukrativere Aufträge freigeschaltet.

Mit ausreichend Kapital können zusätzliche Fahrzeuge gekauft werden, wodurch mehrere Aufträge parallel abgearbeitet werden können.

---

# 2. Designziele

## 2.1 Ziel der Version 0.1

- Stabiler Core-Gameplay-Loop
- Klare Progression über Geld und Ruf
- Skalierbare Auftragsgenerierung
- Erweiterbare technische Architektur
- Minimalistische, aber informative UI
- Sichtbares Zeitfeedback für den Spieler

## 2.2 Nicht-Ziele (bewusst ausgeschlossen)

Diese Systeme sind **nicht Teil von Version 0.1**:

- Weltkarte
- Komplexe Wirtschaftssysteme
- Schadens- oder Risikosysteme
- Fahrzeug-Upgrades
- Story oder narrative Elemente
- Globale Ereignissysteme

---

# 3. Core Gameplay Loop

1. Das Spiel startet mit einem Fahrzeug.
2. Für jedes verfügbare Fahrzeug werden **3 Aufträge generiert**.
3. Der Spieler wählt einen Auftrag.
4. Das Fahrzeug ist während der Auftragsdauer nicht verfügbar.
5. Nach Ablauf des Timers:
   - Geld wird gutgeschrieben
   - Ruf wird erhöht
   - Neue Aufträge werden generiert
6. Der Loop beginnt erneut.

---

# 4. Spielsysteme

---

# 4.1 Fahrzeug-System

## Beschreibung
Fahrzeuge führen Aufträge aus und generieren Einkommen.

## Eigenschaften

```gdscript
id: int
is_available: bool
current_contract: Contract
remaining_time: float
available_contracts: Array
```

## Regeln

- Ein Fahrzeug kann nur **einen Auftrag gleichzeitig** ausführen.
- Während eines laufenden Auftrags kann kein neuer angenommen werden.
- Nach Abschluss wird das Fahrzeug automatisch wieder verfügbar.
- Anschließend werden neue Aufträge generiert.

---

# 4.2 Auftrags-System

## Beschreibung
Aufträge sind zeitbasierte Missionen mit Geld- und Rufbelohnung.

## Eigenschaften

```gdscript
duration: float
reward: int
reputation_gain: int
type: String
```

## Auftragsarten (Version 0.1)

### Standard
Normale Aufträge mit ausgeglichener Dauer und Belohnung.

### Express
- Kürzere Dauer
- Höhere Geldbelohnung
- Weniger Rufgewinn

Neue Auftragsarten werden im Verlauf des Spiels freigeschaltet.

---

# 4.3 Auftragsgenerierung

Aufträge werden dynamisch basierend auf dem **Ruf-Tier** generiert.

Für jedes Fahrzeug werden **3 Angebote** erstellt.

Generierungsprozess:

1. Bestimmung des aktuellen Ruf-Tiers
2. Auswahl eines Auftrags-Tiers über Gewichtung
3. Generierung der Dauer innerhalb des Tier-Bereichs
4. Anwendung der Modifikatoren des Auftragstyps
5. Sortierung der Aufträge nach Dauer

---

# 4.4 Ruf-Tier-System

Der Ruf bestimmt die Qualität der verfügbaren Aufträge.

Beispielhafte Schwellenwerte:

```gdscript
Tier 1:   0 – 9 reputation
Tier 2:  10 – 199
Tier 3: 200 – 499
Tier 4: 500 – 1999
Tier 5: 2000 – 4999
Tier 6: 5000+
```

Mit höheren Tiers werden:

- längere Aufträge verfügbar
- höhere Belohnungen möglich
- mehr Variation eingeführt

---

# 4.5 Zeit-System

Zeit ist die zentrale Ressource des Spiels.

Eigenschaften:

- Timer pro Fahrzeug
- Sekundenbasierte Simulation
- Automatische Abschluss-Erkennung
- Sichtbarer Countdown im UI

Zeitformatierung für bessere Lesbarkeit:

```gdscript
12s
4m
1h20m
```

Zusätzlich zeigt das UI eine **Realtime-Systemuhr**:

```text
HH:MM:SS
```

Diese Uhr dient als visuelles Feedback dafür, dass Zeit im Spiel vergeht.

---

# 4.6 Geld-System

## Startwert

```gdscript
START_MONEY = 500
```

## Einnahmequelle

- Abschluss von Aufträgen

## Verwendung

- Kauf zusätzlicher Fahrzeuge

```gdscript
VEHICLE_COST = 10000
```

---

# 4.7 Ruf-System

## Startwert

```gdscript
START_REPUTATION = 0
```

Ruf wird durch erfolgreiche Aufträge erhöht.

Ruf beeinflusst:

- verfügbare Auftrags-Tiers
- Vielfalt der Aufträge
- Höhe der Belohnungen

Rufgewinn skaliert mit der Auftragsdauer, gewährt jedoch **mindestens 1 Rufpunkt**.

---

# 4.8 Fahrzeug-Erweiterung

Spieler können neue Fahrzeuge kaufen.

Regeln:

- Kauf nur bei ausreichendem Geld
- Fahrzeug wird zur Flotte hinzugefügt
- Fahrzeuge arbeiten unabhängig voneinander
- In Version 0.1 gibt es **keine Unterschiede zwischen Fahrzeugen**

---

# 4.9 Status-Log-System

Ein globales Statuslog speichert wichtige Ereignisse des Spiels.

Beispiele:

- Auftrag gestartet
- Auftrag abgeschlossen
- Fahrzeug gekauft
- Spiel gespeichert / geladen

Der neueste Eintrag wird im UI angezeigt.

Alle Einträge werden im Speicher gehalten und beim Speichern dem Savegame beigefügt.

---

# 5. Benutzeroberfläche

---

# 5.1 Top Bar

Die obere Leiste zeigt zwei Informationsblöcke.

### Company Information

- Geld
- Ruf

### Game Status

- aktuelle Systemzeit (HH:MM:SS)
- Anzahl aktiver Fahrzeuge
- Anzahl inaktiver Fahrzeuge

Beispiel:

```text
14:37:12
Active vehicles: 2
Idle vehicles: 1
```

---

# 5.2 Fahrzeugbereich

Jedes Fahrzeug zeigt:

- Status (verfügbar / unterwegs)
- verbleibende Auftragszeit
- (per Popup) Auswahl von 3 Aufträgen

Beispiel:

```gdscript
12s | $120 | +1 Rep
4m | express | $320 | +2 Rep
```

---

# 5.3 Statusleiste

Die untere Statusleiste zeigt den neuesten Spielevent.

Beispiel:

```gdscript
Vehicle 2 finished express contract: +$180 +1 Rep
```

---

# 5.4 Fahrzeug-Kauf

```gdscript
Buy new vehicle ($10000)
```

Der Button wird deaktiviert, wenn nicht genug Geld vorhanden ist.

---

# 6. Balancing-Prinzipien

Das Balancing verfolgt folgende Ziele:

- sanfte Progression
- keine exponentielle Geldexplosion
- klare Entscheidungsfindung

Designregeln:

- Belohnung skaliert nicht strikt linear mit Dauer
- Rufanstieg bleibt moderat
- Auftragsdauer wächst mit den Ruf-Tiers
- Early Game bleibt schnell und aktiv
- höhere Tiers entschleunigen das Spiel

---

# 7. Technische Architektur

Grundprinzipien:

- Trennung von Game-Logik und UI
- Fahrzeuge werden zentral verwaltet
- Aufträge sind eigene Datenstrukturen
- Auftragsgenerierung über Service-Klasse
- Ereignisbasierte Updates über Signale
- Szenenstruktur für Menüs und UI

---

# 8. Save-System

Der Spielstand wird als JSON gespeichert.

Gespeicherte Daten:

```gdscript
money
reputation
vehicles
vehicle_state
active_contracts
status_log_archive
```

Das Statuslog wird gespeichert, jedoch **nicht wieder geladen**.

---

# 9. Definition of Done (Version 0.1)

Version 0.1 gilt als abgeschlossen, wenn:

- der Gameplay-Loop stabil funktioniert
- mehrere Fahrzeuge parallel arbeiten können
- Ruf-Tiers korrekt skalieren
- Auftragsgenerierung zuverlässig arbeitet
- Save/Load funktioniert
- das Spiel mindestens **15 Minuten stabil spielbar ist**

Version 0.1 soll bis **15.03.2026** fertig sein.

---

# 10. Versions / Roadmap

Die Entwicklung erfolgt iterativ in klar definierten Versionen.

---

## Version 0.1 — Core Loop (MVP)

**Zieltermin:** 15.03.2026

Schwerpunkte:

- Stabiler Gameplay-Loop
- Fahrzeug- und Auftragssystem
- Ruf-Tiers
- Auftragsarten (Standard / Express)
- Status-Log-System
- Save/Load-System
- Grundlegendes Balancing
- Realtime-Uhr im UI
- Fahrzeugstatusanzeige

Diese Version stellt die **erste vollständig spielbare Grundlage** dar.

---

## Version 0.2 — Gameplay Depth

**Zieltermin:** 15.04.2026

Geplante Erweiterungen:

- Weitere Auftragstypen
- Erste Risiko- oder Ereignismechaniken
- Verbesserte UI-Informationen
- Besseres Balancing der Progression
- Erweiterung des Status-Logs
- Erste Quality-of-Life Verbesserungen

Ziel dieser Version ist es, **mehr Spieltiefe und Entscheidungen** zu ermöglichen.

---

## Version 0.3 — World & Systems

**Zieltermin:** 30.05.2026

Geplante Erweiterungen:

- Erste Welt- oder Regionensysteme
- Erweiterte Fahrzeugmechaniken
- Dynamischere Wirtschaft
- Ereignissystem (z.B. Störungen, Marktveränderungen)
- Erweiterte Spielstatistiken
- Weitere UI-Verbesserungen

Diese Version soll den Übergang vom **Prototyp zu einem vollwertigen Managementspiel** vorbereiten.

---

# 11. Erweiterungspotenzial (nicht Teil von Version 0.1)

Geplante Systeme für spätere Versionen:

- Risiko- und Schadenssysteme
- Fahrzeugtypen
- Fahrzeug-Upgrades
- Weltkarte
- Wirtschaftssysteme
- globale Events
- Mitarbeiter
- Finanzsysteme
- Audio und Musik


Eventuelle Umwandlung

1. Game State System
Verwaltet den globalen Spielzustand (z. B. aktiv, pausiert) und steuert, ob die Simulation läuft oder angehalten ist.
2. Time System
Stellt die zentrale Spielzeit bereit und sorgt dafür, dass Aufträge korrekt über Zeit ablaufen und abgeschlossen werden.
3. Vehicle System
Verwaltet alle Fahrzeuge, deren Verfügbarkeit, laufende Aufträge und individuelle Zustände.
4. Contract System
Definiert Aufträge mit Dauer, Belohnung und Rufgewinn und stellt deren Datenstruktur bereit.
5. Contract Generation System
Erzeugt dynamisch neue Aufträge basierend auf dem aktuellen Ruf-Tier und sorgt für eine skalierende Auswahl pro Fahrzeug.
6. Reputation System
Verwaltet den Ruf des Spielers und bestimmt, welche Auftrags-Tiers und Inhalte verfügbar sind.
7. Money System
Verwaltet das Geld des Spielers, inklusive Einnahmen durch Aufträge und Ausgaben für neue Fahrzeuge.
8. Progress System
Aktualisiert laufende Aufträge über die Zeit und erkennt automatisch, wann ein Auftrag abgeschlossen ist.
9. Dispatch System
Ermöglicht die Zuweisung eines Fahrzeugs zu einem Auftrag und startet den jeweiligen Arbeitsprozess.
10. Vehicle Expansion System
Erlaubt den Kauf neuer Fahrzeuge und erweitert damit die parallel bearbeitbaren Aufträge.
11. Status Log System
Erfasst wichtige Spielereignisse (z. B. Auftragsabschluss) und stellt diese für Anzeige und Speicherung bereit.
12. UI System
Zeigt alle relevanten Informationen wie Geld, Ruf, Fahrzeuge und Aufträge an und ermöglicht die Interaktion des Spielers.
13. Save/Load System
Speichert und lädt den Spielzustand (z. B. Geld, Fahrzeuge, Aufträge) persistent als JSON.
14. Formatting / Display System
Formatiert Zeitangaben und andere Werte für die UI (z. B. 1h20m, HH:MM:SS) zur besseren Lesbarkeit.
