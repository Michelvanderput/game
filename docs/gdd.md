# Game Design Document — Nachtlicht (werktitel)

Status: concept v0.1 · eigenaar: de director · Claude houdt dit bij na akkoord.
Werktitel: controleer vóór de storepagina of "Nachtlicht"/"Nightlight" vrij is op Steam.

---

## 1. Kern

**Hook:** *"The Binding of Isaac, maar je bent het vlammetje van een nachtlampje en je licht is je wapen."*

**Design pillars**
1. **Elke pickup verandert je zichtbaar.** Na tien minuten ziet je vlammetje er anders uit en schiet het anders.
2. **Combinaties ontdekken is de beloning.** Items werken standaard op elkaar in; de speler ontdekt combinaties zelf.
3. **Snel, eerlijk, nog één run.** Run van 25–40 min, herstart binnen 3 seconden, elke dood is te verklaren.

**Genre:** top-down actie-roguelite, kamers op een raster, twin-stick schieten. Solo, geen co-op.
**Platform:** Windows + Linux/Steam Deck. Toetsenbord en controller.

---

## 2. Verhaal en wereld

**Premisse.** Mila (8) kan niet slapen. Haar nachtlampje heeft een levend vlammetje: **Pit**. Vannacht ziet Pit dat de schaduwen onder het bed leven en Mila's dromen opeten. Vóór de ochtend daalt Pit af in **de Onderkant** om de dromen terug te halen.

**Toon.** Kinderangst, maar warm en vreemd in plaats van grof. Vergelijk: een spannend prentenboek, geen horrorfilm. Humor in itemnamen ("Vergeten Medicijn", "Knuffelbeer Bram").

**Hoofdstukken (elk 2 verdiepingen + baas):**

| # | Hoofdstuk | Sfeer | Licht | Baas (voorstel) |
|---|---|---|---|---|
| 1 | Onder het Bed | stof, vergeten speelgoed, sokken | schemer | De Stofbal |
| 2 | De Kast | levende kleding, hangers, motten | donker | De Lege Jas |
| 3 | De Kelder | vocht, oude dozen, wat volwassenen niet zeggen | zeer donker | De Ketel |
| 4 | De Droomput (1.0) | wat Mila écht bang maakt | wisselend | De Nachtmerrie |

**Vertelwijze (weinig tekst):**
- Intro: 4 stilstaande pixelplaatjes, zonder of met één regel tekst.
- Na elke baas: een **teruggehaalde droom**, een kort beeld van Mila's leven (school, verhuizing, een ruzie die ze hoorde). Zo bouwt het verhaal op wat de schaduwen eigenlijk zijn.
- Eindes: "De ochtend" (normaal), plus geheime eindes die later ontgrendeld worden.
- Open vraag voor de director: wat is Mila's echte zorg? Voorstel: haar ouders gaan verhuizen en ze durft niet te zeggen dat ze bang is.

**Hub: Mila's kamer.** Tussen runs. Teruggebrachte **droomscherven** (meta-valuta) zetten nieuwe dingen in de kamer, en elk ding ontgrendelt iets in de Onderkant.

---

## 3. Core loop

**Binnen een run:** kamer binnen → deuren dicht → vijanden verslaan → beloning/pickups → volgende kamer kiezen → schatkamer (item) → winkel → baas → verdieping dieper.

**Tussen runs:** dood of overwinning → droomscherven → iets in Mila's kamer ontgrendelen → nieuwe items in de pools of een nieuw personage → nieuwe run.

**Gegarandeerde groei (Zelda-structuur):** elke verdieping heeft een schatkamer met een item, en de baas laat een item vallen.

---

## 4. Speler

**Besturing:** bewegen met WASD of linkerstick; schieten in 4 richtingen met de pijltjes of ABXY/rechterstick; actief item met spatie of RB; rotje met E of LB.

**Stats (startwaarden, worden live getuned):**

| Stat | Start | Opmerking |
|---|---|---|
| Vlam (levens) | 3 vlammen | in halve vlammen; max 12 |
| Was (extra pantser) | 0 | gaat eerst verloren, geen max-vlam |
| Schade | 3.0 | |
| Vuursnelheid | 2.5 schoten/s | soft cap |
| Bereik | 6.5 tiles | |
| Schotsnelheid | 7 tiles/s | |
| Loopsnelheid | 1.0 (×basis) | 0.5–2.0 |
| Geluk | 0 | kans op status-effecten en betere drops |
| **Gloed** | 3.5 tiles | **eigen stat:** straal van je licht |

**Stat-formule:** `eind = (basis + som(optellingen)) × product(vermenigvuldigers)`, daarna eventuele cap.

---

## 5. Itemsysteem (de kern)

### 5.1 Soorten

| Soort | Wat | Voorbeeld |
|---|---|---|
| Stat | verhoogt of verlaagt stats | Lontje: +vuursnelheid |
| Schot-modifier | verandert patroon, vorm, baan of botsing | Mottenvleugel: zoekende schoten |
| Status | kans op effect bij raken | Kaarsvet: brand |
| Trigger | effect bij een gebeurtenis | Wraakvonk: vonkenkrans bij geraakt worden |
| Familiar/orbital | helpertje dat volgt of cirkelt | Knuffelbeer Bram |
| Actief | knop-item, laadt op per leeggemaakte kamer | Dobbelsteen van Opa |

Daarnaast **verbruiksartikelen**: *Snoepjes* (onbekend effect tot je er één eet; zoals pillen in Isaac).

### 5.2 Ontwerpregels
1. **Bijna alles stapelt.** Hetzelfde item twee keer = sterker effect.
2. **Elk item is zichtbaar**: kleur, vorm of spoor van het schot, of een detail op Pit.
3. **Mysterie:** eerste keer alleen naam + slogan ("Het brandt een beetje"); volledige uitleg vanaf de tweede keer dat je het item ziet.
4. **Weinig pure stat-items.** De meeste items veranderen gedrag; dat is waar combinaties ontstaan.
5. **Een paar items met een nadeel** (+schade, −snelheid), altijd met een duidelijke afweging.

### 5.3 Projectiel-pipeline (zo ontstaan synergieën vanzelf)

Elk schot wordt gebouwd als `ShotSpec`. Alle actieve modifiers worden in **vaste volgorde** toegepast:

1. **Trigger:** wanneer er geschoten wordt (normaal, opladen, automatisch).
2. **Patroon:** aantal en spreiding (dubbel, waaier van 3, ook achteruit).
3. **Vorm:** grootte, schade-schaal.
4. **Baan:** recht, zoekend, spiraal, golf, boemerang. Er is maar één *hoofdbaan*; bij conflict wint de hoogste prioriteit, tenzij een synergie anders zegt.
5. **Botsing:** doorborend, spectraal (door rotsen), stuiterend.
6. **Bij raken:** status-effecten, explosie, splitsen.
7. **Bij verdwijnen:** splitsen, vuurplas, ontploffen.
8. **Uiterlijk:** kleur, licht en spoor, berekend uit alle modifiers.

**Regels:**
- Kind-projectielen (bijv. van splitsen) erven alle modifiers **behalve** splitsen. Maximaal 1 niveau diep, zodat er geen eindeloze ketting ontstaat.
- Elke combinatie van twee schot-modifiers moet zonder crash en boven 60 fps werken. Dit wordt **automatisch getest** voor alle paren.

### 5.4 Ontworpen synergieën
Naast de vanzelf ontstane combinaties: handgemaakte paren met een melding in beeld (zoals in Enter the Gungeon). Streven: ongeveer 1 ontworpen synergie per 5 items. Zie `docs/items.md`.

### 5.5 Transformaties
Drie items met dezelfde set-tag geven een **transformatie**: nieuw uiterlijk plus een bonus. Drie sets bij de demo (Kaars, Mot, Knuffel), zes bij launch.

### 5.6 Pools en zeldzaamheid
- Pools per kamertype: **Schat** (modifiers, status, familiars), **Winkel** (stats, actieven, verbruik), **Baas** (stats, Was), **Geheim** (zeldzaam, vreemd), **Schaduwruil** (sterk, kost max-vlam).
- Kwaliteit 0–4 bepaalt de kans; een pity-regel voorkomt drie verdiepingen zonder item van kwaliteit 2 of hoger.
- Een item komt per run maar één keer voor, tenzij een effect dat expliciet toestaat.

---

## 6. Pickups en economie

| Pickup | Isaac-equivalent | Gebruik |
|---|---|---|
| Knopen | munten | winkel, sommige machines |
| Rotjes | bommen | rotsen opblazen, geheime kamers openen, schade |
| Sleutels | sleutels | schatkamer (vanaf verdieping 2), kistjes |
| Vlammetjes (½ of 1) | hartjes | genezen |
| Was | soul hearts | extra pantser |
| Lucifers | batterijen | actief item opladen |
| Snoepjes | pillen | onbekend effect, wordt bekend na eten |

---

## 7. Verdiepingen en kamers

- Raster van 9×8 vakken; 8–12 kamers op verdieping 1, oplopend tot 14–18.
- Generatie: random walk vanaf het midden met regels tegen klonten; baas in het verste doodlopende eind, schatkamer en winkel in andere eindes, geheime kamer op een leeg vak met veel buren.
- Kamerinhoud uit **handgemaakte templates** (20×11 tiles) per type, hoofdstuk en moeilijkheid; 30–50 per hoofdstuk bij launch.
- Deuren gaan dicht tot de kamer leeg is. Minimap toont bezochte kamers en kamers die je al hebt gezien.
- **Schaduwruil-kamer:** kan na de baas verschijnen; grotere kans als je die verdieping niet geraakt bent.

### Licht en duisternis (eigen mechaniek, fase 2)
- Elke kamer heeft een lichtniveau: verlicht, schemer of donker.
- In het donker zie je alleen wat binnen je **gloed** valt; vijanden daarbuiten zijn alleen oogjes.
- Schaduwvijanden krimpen en worden langzamer binnen je licht.
- De kleur van je licht volgt je status-items (oranje = brand, groen = gif, blauw = ijs).
- Pas bouwen nadat de basis (bewegen, schieten, items stapelen) leuk voelt.

---

## 8. Vijanden en bazen (scope)

**Demo:** 8 vijanden, 1 baas. **Early Access:** ~25 vijanden, 3 bazen.

Archetypen voor hoofdstuk 1: Stofje (achtervolger), Sokslang (golvende beweging), Knikkerschieter (schutter), Speelgoedsoldaat (tank met schild aan voorkant), Stofwolk (splitst bij dood), Lampenkap (stilstaande toren), Mot (vliegt over gaten, aangetrokken door je licht), Kruimel (zwerm van 5).

Elke aanval heeft een **telegraph** van minimaal 0,4 s (oplichten of opzwellen).

---

## 9. Meta-progressie

- **Droomscherven**: krijg je ook als je doodgaat (meer naarmate je dieper komt).
- Uitgeven in **Mila's kamer**: elk object ontgrendelt items in de pools, een nieuwe kamersoort of een personage.
- **Personages (voorstel):** Pit (allround), Glim (glimworm in een jampot: veel gloed, weinig schade), Bliep (zaklamp-robot: schiet een korte straal, laadt op).
- Na de eerste overwinning: **Nachtstanden 1–10**, oplopende moeilijkheid (zoals heat/ascension).
- Regel: ontgrendelingen moeten keuzes verbreden, niet alleen sterker maken.

---

## 10. Art en audio

- 320×180, tiles 16 px, Pit 12×12, vijanden 12–16 px, bazen 32–64 px.
- Palet van 8–12 kleuren, dikke donkere outline, grote ogen, duidelijke silhouetten.
- **Signature:** dynamisch 2D-licht (Light2D + occluders) over eenvoudige sprites; ordered dithering in schaduwen.
- Animatie vooral procedureel (squash & stretch, wiebelen, flits), 1–2 frames per vijand.
- Sprites worden gemaakt met `tools/sprites/` en door de director bijgewerkt in Pixelorama.
- Audio door mensen gemaakt: SFX met jsfxr/ChipTone, muziek met BeepBox of FamiStudio, of CC0.
- Steam AI-disclosure: sprites vermelden als AI-ondersteund, bewerkt door de ontwikkelaar.

---

## 11. Scope per mijlpaal

| | Vertical slice | Demo (Next Fest) | Early Access |
|---|---|---|---|
| Hoofdstukken | 1 (1 verdieping) | 1 (2 verdiepingen) | 3 |
| Personages | 1 | 1 | 2–3 |
| Vijanden | 5 | 8 | ~25 |
| Bazen | 1 | 1 | 3 |
| Items | 15 + 3 actief | 30 | ~80 |
| Transformaties | 0 | 3 | 5–6 |

---

## 12. Open vragen voor de director
- [ ] Werktitel en de echte zorg van Mila (verhaal).
- [ ] Schieten in 4 richtingen (Isaac) of 8 richtingen? Advies: 4, zoals Isaac; testen in de slice.
- [ ] Palet kiezen (art-proef).
- [ ] Licht als kernmechaniek houden na de eerste playtests?
