# CLAUDE.md — Nachtlicht (werktitel)

Top-down actie-roguelite in de lijn van The Binding of Isaac. Solo-ontwikkelaar (de "director") + Claude Code.
Lees bij elke nieuwe taak eerst `docs/gdd.md` en de taak in `docs/tasks/`.

## Tech
- Engine: **Godot 4.7**, alleen 2D. Taal: **GDScript met verplichte statische types** (`var hp: int = 3`, `func f(x: float) -> void`).
- Basisresolutie **320×180**. Project Settings: stretch mode `viewport`, aspect `keep`, scale mode `integer`,
  default texture filter `Nearest`, `snap_2d_transforms_to_pixel` en `snap_2d_vertices_to_pixel` aan.
- Tile-grootte 16 px. Eén kamer = één scherm = 20×11 tiles.
- Tests: eigen kleine runner in GUT-stijl (`tests/run_tests.gd`, basisklasse `TestCase` in `tests/test_case.gd`).
  Elke `tests/**/test_*.gd` extends `TestCase`; elke `test_*`-methode draait op een verse instantie en mag `await`en.
  Script- en engine-fouten tijdens een test laten die test falen. Draai headless:
  `godot --headless --import` (eerst, en na nieuwe `class_name`s of PNG's), dan
  `godot --headless -s res://tests/run_tests.gd` (optioneel `-- test_rng` om te filteren). Exit-code 1 bij falen.
  GUT kan later alsnog; de asserts heten hetzelfde (`assert_eq`, `assert_true`, `assert_almost_eq`).
- Sprites opnieuw bouwen: `python tools/sprites/make_sprites.py` (schrijft ook `src/core/palette.gd`), daarna `python tools/palette_check.py`.
- Versiebeheer: Git + Git LFS (`*.png`, `*.wav`, `*.ogg`, `*.pxo`).

## Mappen
```
src/core/      game state, RNG-service, EventBus, save, settings
src/player/    speler, input, stats
src/combat/    projectielen, hitbox/hurtbox, schade, status-effecten
src/enemies/   vijanden + gedrag (state machines)
src/rooms/     kamers, deuren, verdieping-generatie
src/items/     item-systeem, modifiers, synergieën, transformaties
src/pickups/   knopen, rotjes, sleutels, hartjes
src/ui/        HUD, menu's, minimap
src/debug/     console, spawnmenu, god mode
data/          items, vijanden, kamers als .tres-Resources
assets/art/    sprites (bron: tools/sprites/*.txt → gegenereerde PNG's)
tools/         Python-scripts (sprite-generator, palet-check)
tests/         GUT-tests, gespiegelde mapstructuur van src/
docs/          gdd.md, items.md, tasks/
```

## Architectuurregels
1. **Composition boven inheritance.** Gedrag in kleine componenten (`Health`, `Hitbox`, `Hurtbox`, `Knockback`, `LightSource`).
2. **Data-driven.** Items, vijanden en kamers zijn Resources in `data/`. Nooit content hardcoden in scripts.
3. **Eén RNG-service** (`src/core/rng.gd`) met seed; nooit `randi()`/`randf()` direct. Aparte streams per systeem (kaart, loot, gevecht) zodat een run met dezelfde seed identiek is.
4. **EventBus** (autoload) voor losse koppeling: `enemy_died`, `room_cleared`, `item_picked_up`, `player_hit`, enz.
5. **Projectiel-pipeline** (kern van de synergieën, zie `docs/gdd.md` §5): schoten worden gebouwd uit een `ShotSpec` waarop alle modifiers in vaste volgorde worden toegepast. Nieuwe schot-items voegen een modifier toe, nooit een special case in de projectielcode.
6. Alle speelbare waarden (snelheid, schade, cooldowns) staan in Resources of `@export`-variabelen zodat de director ze live kan tunen.
7. Code, identifiers en comments in het **Engels**. Spelersteksten via vertaalsleutels (`tr("ITEM_EMBER_NAME")`), Nederlands en Engels in `data/i18n/`.

## Art-regels
- Sprites worden gemaakt met `tools/sprites/` (tekstraster + palet → PNG via Python/Pillow). Palet: `assets/art/palette.png`.
- Geen kleuren buiten het palet; `tools/palette_check.py` moet slagen.
- Animatie zoveel mogelijk procedureel (tweens/shaders: squash & stretch, wiebelen, flits), 1–2 frames per vijand.
- Tot de art-richting is goedgekeurd: placeholders als gekleurde vormen.
- Genereer **geen** muziek, geluid of vertalingen voor spelers.

## Werkwijze
- Werk taak voor taak uit `docs/tasks/`. Begin met een kort plan; wacht op akkoord bij twijfel over ontwerp.
- Kleine stappen; na elke taak: tests groen, korte samenvatting, voorgestelde commit-message.
- Voeg voor elk nieuw systeem minstens één test toe (RNG-determinisme, generatie, modifiers).
- Vraag de director bij smaakbeslissingen (game feel, art, balans). Kies bij puur technische keuzes zelf de eenvoudigste oplossing en meld het.
- Houd `docs/gdd.md` actueel als een ontwerpbeslissing verandert (na akkoord).
