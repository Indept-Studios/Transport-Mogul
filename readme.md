# Transport Mogul 
## Game Design Document (GDD)  
### Version 0.1 (MVP)

---

# 1. Spielübersicht

## 1.1 Arbeitstitel
Transport Mogul

## 1.2 Genre
Wirtschafts-/Management-Spiel (2D, minimalistisch)

## 1.3 Kernidee
Der Spieler leitet ein kleines Transportunternehmen.  
Er nimmt Aufträge an, schickt Fahrzeuge auf zeitbasierte Missionen und erwirtschaftet Geld und Ruf.  
Durch steigenden Ruf werden lukrativere Aufträge freigeschaltet.  
Mit ausreichend Kapital können zusätzliche Fahrzeuge erworben werden.

---

# 2. Designziele

## 2.1 Ziel der Version 0.1

- Implementierung eines stabilen Kern-Gameplay-Loops
- Klare Progression über Geld und Ruf
- Erweiterbare technische Struktur
- Begrenzter Scope zur sicheren Fertigstellung

## 2.2 Nicht-Ziele (bewusst ausgeschlossen)

- Simulation einer Weltkarte
- Komplexe Wirtschaftssysteme
- Risiko- oder Schadenssysteme
- Fahrzeugtypen oder Upgrades
- Narrative Elemente
- Ereignissysteme

---

# 3. Core Gameplay Loop

1. Spiel startet mit einem Fahrzeug.
2. Für jedes verfügbare Fahrzeug werden 3 Aufträge generiert.
3. Spieler wählt einen Auftrag.
4. Fahrzeug ist für die Dauer des Auftrags nicht verfügbar.
5. Nach Ablauf:
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

```
is_available: bool
current_contract: Contract
remaining_time: float
```

## Regeln

- Ein Fahrzeug kann nur einen Auftrag gleichzeitig ausführen.
- Während der Laufzeit ist es nicht auswählbar.
- Nach Abschluss wird es automatisch wieder verfügbar.
- Danach werden neue Aufträge generiert.

---

# 4.2 Auftrags-System

## Beschreibung
Aufträge sind zeitbasierte Missionen mit Belohnung und Rufgewinn.

## Eigenschaften

```
duration: float
reward: int
reputation_gain: int
```

## Generierung

- Pro verfügbarem Fahrzeug werden 3 Aufträge erzeugt.
- Dauer wird zufällig im definierten Bereich bestimmt.
- Belohnung und Ruf skalieren mit Dauer und aktuellem Ruf.

## Beispiel-Formel (MVP)

```
duration = randf_range(MIN_DURATION, MAX_DURATION) + reputation * 0.5
reward = duration * MONEY_FACTOR + reputation * 2
reputation_gain = duration / 5
```

---

# 4.3 Zeit-System

## Beschreibung
Zeit ist die zentrale Ressource des Spiels.

## Anforderungen

- Timer pro Fahrzeug oder zentral verwaltet
- Sekundenbasiert
- Nach Ablauf wird Abschluss-Event ausgelöst
- Optional sichtbarer Countdown

---

# 4.4 Geld-System

## Startwert

```
START_MONEY = 500
```

## Einnahmequelle

- Abschluss von Aufträgen

## Verwendung

- Kauf zusätzlicher Fahrzeuge

---

# 4.5 Ruf-/Prestige-System

## Startwert

```
START_REPUTATION = 0
```

## Funktion

- Steigert Qualität und Dauer zukünftiger Aufträge
- Erhöht Belohnung
- Erhöht Ruf-Gewinn

## Skalierung (einfach, linear)

```
reward_multiplier = 1 + reputation * 0.05
```

Keine exponentielle Skalierung in Version 0.1.

---

# 4.6 Fahrzeug-Erweiterungssystem

## Beschreibung
Spieler kann neue Fahrzeuge kaufen.

## Parameter

```
VEHICLE_COST = 1000
```

## Regeln

- Kauf nur möglich bei ausreichendem Geld
- Neues Fahrzeug wird zur Fahrzeugliste hinzugefügt
- Jedes Fahrzeug funktioniert unabhängig
- Keine Unterschiede zwischen Fahrzeugen

---

# 5. Benutzeroberfläche

---

# 5.1 Globale Anzeige

- Geld
- Ruf

---

# 5.2 Fahrzeugbereich

Für jedes Fahrzeug:

- Statusanzeige:
  - "Verfügbar"
  - "Unterwegs (X Sekunden)"
- 3 Auftragsbuttons (nur wenn verfügbar)

---

# 5.3 Auftragsanzeige (Textformat)

```
12s | $140 | +3 Ruf
```

---

# 5.4 Kauf-Button

```
Neues Fahrzeug kaufen ($1000)
```

- Deaktiviert bei unzureichendem Geld

---

# 6. Balancing-Parameter

| Parameter         | Beispielwert |
|------------------|--------------|
| MIN_DURATION     | 5            |
| MAX_DURATION     | 20           |
| MONEY_FACTOR     | 10           |
| REPUTATION_SCALE | 0.05         |
| VEHICLE_COST     | 1000         |

Alle Werte sind als Konstanten definiert.

---

# 7. Technische Anforderungen

- Trennung von Spiel-Logik und UI
- Fahrzeuge werden in einer Liste verwaltet
- Aufträge als eigene Datenstruktur
- Ereignisgesteuerter Abschluss (Signal oder Callback)
- Mehrere Fahrzeuge parallel möglich

---

# 8. Definition of Done

Version 0.1 gilt als abgeschlossen, wenn:

- Der Gameplay-Loop stabil funktioniert
- Mehrere Fahrzeuge parallel Aufträge ausführen können
- Geld- und Ruf-Skalierung korrekt arbeitet
- Keine Blocker oder Logikfehler auftreten
- Das Spiel mindestens 15 Minuten stabil spielbar ist

---

# 9. Erweiterungspotenzial (nicht Teil von 0.1)

- Risiko- oder Schadenssystem
- Fahrzeugtypen
- Upgrades
- Weltkarte
- Events
- Wirtschaftssystem
- Mitarbeiter
- Kredit- oder Finanzsystem
- Speichern/Laden
- Audio

---

# 10. Scope-Prinzip für Version 0.1

Diese Version enthält ausschließlich:

- Den Kern-Gameplay-Loop
- Grundlegende Progression
- Minimale UI
- Erweiterbare Architektur

Alles Weitere wird bewusst auf spätere Versionen verschoben.
