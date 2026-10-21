# Taak 001 — Basis-setup: Pit beweegt en schiet in één kamer

## Doel
Van een lege map naar een Godot 4.7-project waarin Pit (placeholder) pixel-perfect beweegt en schiet in één testkamer van 20×11 tiles, met de fundamenten (RNG, EventBus, stats, ShotSpec) waar alle volgende taken op bouwen.

## Stappen
1. **Omgeving controleren.** Zoek de Godot 4.7-executable (PATH, of omgevingsvariabele `GODOT`). Niet gevonden? Stop en vraag het pad. Controleer ook Python 3 en Pillow (`pip install pillow`).
2. **Git:** `git init`, `.gitignore` voor Godot (`.godot/`, `*.import` niet negeren), `.gitattributes` met Git LFS voor `*.png *.wav *.ogg *.pxo`.
3. **project.godot** met de instellingen uit CLAUDE.md (320×180, integer scaling, Nearest, pixel snap). Venstergrootte standaard 1280×720.
4. **Mappenstructuur** uit CLAUDE.md aanmaken.
5. **GUT** installeren in `addons/gut` en een eerste lege test laten slagen met het headless commando.
6. **Autoloads:**
   - `EventBus` met de signals uit CLAUDE.md.
   - `Rng`: seed instellen/opvragen, aparte streams `map`, `loot`, `combat`; functies `randi_range`, `randf`, `pick`, `weighted_pick`.
   - `GameState`: huidige seed, runstatus.
7. **Input map:** bewegen (WASD + linkerstick), schieten 4 richtingen (pijltjes + ABXY + rechterstick naar dichtstbijzijnde richting), `restart` (R), `debug_toggle` (F1).
8. **PlayerStats** als Resource met de stats en startwaarden uit `docs/gdd.md` §4, inclusief de stat-formule (optellingen en vermenigvuldigers).
9. **Componenten:** `Health` (halve vlammen, onkwetsbaarheid na treffer), `Hitbox`, `Hurtbox`.
10. **Speler (Pit):** 8-richtingen beweging met korte acceleratie, schieten volgens vuursnelheid; bij schieten in een richting kijkt Pit die kant op. Placeholder: oranje cirkel van 12 px.
11. **ShotSpec + Projectile:** basisvelden (richting, snelheid, bereik, schade, grootte, kleur) en een lege lijst modifiers. Projectiel verdwijnt na bereik of tegen een muur, met een klein plofje (partikel).
12. **Testkamer:** 20×11 tiles, muren rondom, 4 deuropeningen (dicht, alleen visueel), een paar rotsen. Placeholder-tiles uit het palet.
13. **Oefendoel:** stilstaande dummy met `Health` (20 HP), witte flits en klein getal bij schade.
14. **Debug-overlay (F1):** seed, FPS, stats van Pit. **R** herstart de scène met een nieuwe seed.
15. **Sprite-tool (skelet):** `tools/sprites/make_sprites.py` leest `tools/sprites/*.txt` (tekstraster met paletletters) en `assets/art/palette.png`, en schrijft PNG's naar `assets/art/export/`. Lever één voorbeeld: `pit.txt` (12×12). Plus `tools/palette_check.py`. Gebruik een tijdelijk palet van 10 kleuren (warme oranjes, diep blauw-zwart, crème).
16. **Tests:**
    - Rng: dezelfde seed geeft dezelfde reeks per stream.
    - PlayerStats: formule `(basis + optellingen) × vermenigvuldigers` klopt.
    - Health: schade, onkwetsbaarheid, dood-signal.
    - Projectile: verdwijnt na bereik.

## Acceptatiecriteria
- [ ] Project opent zonder fouten of waarschuwingen in Godot 4.7.
- [ ] Pit beweegt soepel en pixel-perfect; geen wazige pixels bij 1280×720 en 1920×1080.
- [ ] Schieten werkt met toetsenbord en controller; vuursnelheid komt overeen met de stat.
- [ ] De dummy krijgt schade, flitst en toont het getal.
- [ ] Alle tests slagen headless.
- [ ] `make_sprites.py` maakt `pit.png`; `palette_check.py` slaagt.
- [ ] Afgesloten met samenvatting, lijst van tuning-variabelen en een voorgestelde commit-message.

## Niet in deze taak
Items, vijanden met gedrag, deuren die werken, verdieping-generatie, licht, echte art, menu's.

## Volgende taken (ter info)
- 002 Projectiel-pipeline met modifiers + de 10 schot-items uit `docs/items.md`, met een paartest voor alle combinaties.
- 003 Item-oppakken: pedestals, item-Resources, stat- en status-items, item-popup (mysterie-regel).
- 004 Drie vijanden (Stofje, Knikkerschieter, Stofwolk) met telegraphs.
- 005 Kamers: deuren sluiten/openen, overgangen, 10 templates.
- 006 Verdieping-generatie + minimap + 1.000-seeds-test.
- 007 Pickups (knopen, rotjes, sleutels, vlammetjes) + schatkamer en winkel.
- 008 Art-proef: Pit + 3 vijanden in 3 paletten als code-sprites.
- 009 Baas De Stofbal + run-einde + snelle herstart.
