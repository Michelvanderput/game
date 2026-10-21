# Start hier — Nachtlicht in Claude Code

## 1. Eenmalig installeren
1. **Godot 4.7** (standaardversie, niet .NET) van godotengine.org. Zet de map in je PATH, of maak een omgevingsvariabele `GODOT` met het volledige pad naar de executable.
2. **Git** en **Git LFS** (`git lfs install`).
3. **Python 3** + Pillow: `pip install pillow`.
4. **Claude Code** (terminal of desktop-app) en inloggen met je Claude-account.
5. **Pixelorama** (gratis) om sprites bij te werken.

## 2. Project klaarzetten
1. Maak een lege map, bijvoorbeeld `~/games/nachtlicht`.
2. Pak dit startpakket daarin uit, zodat `CLAUDE.md` en `docs/` direct in die map staan.
3. Open een terminal in die map en start `claude` (of open de map in de Claude-app).

## 3. Plak deze startopdracht

```
Lees CLAUDE.md, docs/gdd.md, docs/items.md en docs/tasks/001-basis-setup.md.
Voer taak 001 uit. Maak eerst een plan en wacht op mijn akkoord.
Werk daarna stap voor stap, draai na elk onderdeel de tests,
en sluit af met een samenvatting, de lijst met tuning-variabelen
en een voorgestelde commit-message. Vraag het me als je Godot,
Python of een tool niet kunt vinden.
```

## 4. Daarna, elke keer
- Eén taak per sessie (`docs/tasks/002-...`). Taken die nog niet bestaan schrijf je zelf, of je vraagt in de chat-app om ze uit te werken.
- Speel na elke taak 5–10 minuten en geef concrete feedback ("schieten voelt traag, halveer de cooldown").
- Commit na elke geslaagde taak.
- Ontwerpvragen, verhaal, onderzoek en planning: in de Claude-chat en in het plan-document. Bouwen: in Claude Code.
