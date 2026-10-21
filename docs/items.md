# Itemlijst v1 — eerste 30 items

Alle waarden zijn startwaarden voor tuning. `id` = bestandsnaam van de Resource in `data/items/`.
Q = kwaliteit 0–4. Pool: S = schat, W = winkel, B = baas, G = geheim.

## Stat-items (8)

| id | NL | EN | Q | Pool | Effect | Zichtbaar | Set |
|---|---|---|---|---|---|---|---|
| melting_point | Smeltpunt | Melting Point | 1 | S,B | +0.7 schade | vlam iets roder | Kaars |
| fuse | Lontje | Fuse | 1 | S,B | +0.5 vuursnelheid | lontje bovenop Pit | Kaars |
| long_wick | Lange Lont | Long Wick | 1 | B,W | +2 bereik, +0.5 schotsnelheid | langere vlampunt | — |
| slippers | Pantoffels | Slippers | 1 | W,B | +0.2 loopsnelheid | pluizige voetjes | Knuffel |
| pillow_clover | Klavertje uit het Kussen | Pillow Clover | 1 | S,W | +1 geluk | groen blaadje | Knuffel |
| extra_wax | Extra Was | Extra Wax | 1 | B,W | +1 max vlam, geneest 1 | dikkere voet | Kaars |
| mirror_shard | Spiegelscherf | Mirror Shard | 2 | S | +1.5 gloed, +0.3 schade | glinstering in licht | — |
| sugar_cube | Suikerklontje | Sugar Cube | 2 | B | +0.2 op alle stats | witte rand | — |

## Schot-modifiers (10)

| id | NL | EN | Q | Pool | Effect | Zichtbaar | Set |
|---|---|---|---|---|---|---|---|
| twin_spark | Tweelingvonk | Twin Spark | 2 | S | 2 parallelle schoten, ×0.8 schade | dubbele vonk | — |
| triple_flame | Drievlam | Triple Flame | 3 | S | waaier van 3, ×0.7 vuursnelheid | 3 vonken in waaier | — |
| moth_wing | Mottenvleugel | Moth Wing | 3 | S | schoten zoeken vijanden | vleugeltjes aan vonk | Mot |
| ghost_sock | Spooksok | Ghost Sock | 2 | S,G | spectraal: door rotsen | doorschijnende vonk | — |
| knitting_needle | Breinaald | Knitting Needle | 2 | S | doorborend | puntige vonk | — |
| marble | Knikker | Marble | 2 | S,W | stuitert 2× tegen muren | ronde glazen vonk | — |
| yoyo | Jojo | Yo-yo | 2 | S | boemerang: keert terug naar Pit | draadje achter schot | — |
| spinning_top | Tolletje | Spinning Top | 2 | S,G | spiraalbaan naar buiten | draaiend spoor | — |
| split_spark | Splijtvonk | Split Spark | 3 | S | bij verdwijnen 4 kleine vonken (×0.4 schade) | barstjes in vonk | — |
| fat_drop | Dikke Druppel | Fat Drop | 2 | S,B | ×1.6 grootte, +1 schade, ×0.8 schotsnelheid | grote druppel | Kaars |

## Status-items (4)

| id | NL | EN | Q | Pool | Effect | Lichtkleur | Set |
|---|---|---|---|---|---|---|---|
| candle_grease | Kaarsvet | Candle Grease | 2 | S | 15% (+geluk) kans op brand, 3 s | oranje | Kaars |
| forgotten_medicine | Vergeten Medicijn | Forgotten Medicine | 2 | S,G | 15% kans op gif, 4 s | groen | — |
| ice_cube | IJsblokje | Ice Cube | 2 | S | 10% kans op bevriezen, 1.5 s | lichtblauw | — |
| lullaby | Nachtliedje | Lullaby | 3 | S,G | 10% kans vijand valt in slaap, 2 s | paars | Mot |

## Triggers en familiars (4)

| id | NL | EN | Q | Pool | Effect | Set |
|---|---|---|---|---|---|---|
| moth_swarm | Mottenzwerm | Moth Swarm | 2 | S | 2 motjes cirkelen om Pit, blokkeren kogels | Mot |
| teddy_bram | Knuffelbeer Bram | Teddy Bram | 2 | S | volgt Pit, schiet vonken met ×0.5 schade | Knuffel |
| dusty_lamp | Stoffige Lamp | Dusty Lamp | 1 | W | kamer leeg: 25% kans op ½ vlam | — |
| spite_spark | Wraakvonk | Spite Spark | 2 | S,B | geraakt worden: 8 vonken in een krans | — |

## Actieve items (4)

| id | NL | EN | Q | Pool | Lading | Effect |
|---|---|---|---|---|---|---|
| matchstick | Lucifer | Matchstick | 1 | W | 2 kamers | flits door de hele kamer: 10 schade, vijanden 1 s verblind |
| flashlight | Zaklamp | Flashlight | 2 | S,W | 1 kamer | 4 s lichtkegel; schaduwvijanden krimpen en nemen ×2 schade |
| grandpas_die | Dobbelsteen van Opa | Grandpa's Die | 3 | G | 6 kamers | items in deze kamer opnieuw rollen |
| alarm_clock | Wekker | Alarm Clock | 2 | W | 3 kamers | 3 s alles behalve Pit op halve snelheid |

## Ontworpen synergieën (6)

Verschijnen met een naam in beeld wanneer ze actief worden.

| Naam | Items | Effect |
|---|---|---|
| Klaterregen | Jojo + Splijtvonk | splitst pas bij terugkeer; de splinters keren ook terug |
| Vuurvlinders | Kaarsvet + Mottenvleugel | zoekende vonken laten een kort vuurspoor achter |
| Flipperkast | Knikker + Breinaald | doorborend én stuiterend, +1 extra stuit |
| Koude Wraak | IJsblokje + Wraakvonk | wraakvonken bevriezen altijd |
| Discobal | Zaklamp + Spiegelscherf | de lichtkegel wordt een volle cirkel |
| Beste Vriendjes | Knuffelbeer Bram + Tweelingvonk | Bram schiet ook dubbel |

## Transformaties (3)

| Transformatie | Set (3 items nodig) | Effect | Uiterlijk |
|---|---|---|---|
| Fakkel | Kaars: Smeltpunt, Lontje, Extra Was, Kaarsvet, Dikke Druppel | +1 max vlam, schoten laten kleine vuurplassen achter | Pit wordt een hoge fakkelvlam |
| Mottenkoning | Mot: Mottenvleugel, Nachtliedje, Mottenzwerm | vliegen over gaten, +2 motjes | vleugels en voelsprieten |
| Knuffelpantser | Knuffel: Pantoffels, Klavertje, Knuffelbeer Bram | eerste treffer per kamer wordt genegeerd | stoffen lapje met knoopje |

## Natuurlijke combinaties die moeten werken (testlijst)
- Tweelingvonk + Drievlam → 6 schoten (2 per richting in waaier).
- Mottenvleugel + Jojo → zoekt op de heenweg, keert daarna terug.
- Splijtvonk + elke status → splinters erven de status.
- Spooksok + Knikker → door rotsen heen, stuitert alleen tegen buitenmuren.
- Tolletje + Mottenvleugel → spiraal; zoekend gedrag wint na 0,5 s (prioriteitsregel).
