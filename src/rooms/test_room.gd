class_name TestRoom
extends Node2D
## One 20x11 room built from a text layout. Doors are visual only for now.
## Layout legend: '#' wall, '.' floor, 'o' rock.

enum Tile { FLOOR, WALL, ROCK, DOOR }

const TILES_TEXTURE: Texture2D = preload("res://assets/art/export/tiles.png")
const SOLID_TILES: Array[Tile] = [Tile.WALL, Tile.ROCK]
const LEGEND: Dictionary[String, Tile] = {".": Tile.FLOOR, "#": Tile.WALL, "o": Tile.ROCK}
## Physics layer 1 ("world").
const WORLD_LAYER: int = 1

@export var layout: PackedStringArray = []

@onready var tiles: TileMapLayer = $Tiles


func _ready() -> void:
	tiles.tile_set = TestRoom.build_tile_set()
	_paint_layout()
	_place_doors()


static func build_tile_set() -> TileSet:
	var tile_set := TileSet.new()
	tile_set.tile_size = Vector2i(Grid.TILE_SIZE, Grid.TILE_SIZE)
	tile_set.add_physics_layer()
	tile_set.set_physics_layer_collision_layer(0, WORLD_LAYER)
	tile_set.set_physics_layer_collision_mask(0, 0)
	var source := TileSetAtlasSource.new()
	source.texture = TILES_TEXTURE
	source.texture_region_size = Vector2i(Grid.TILE_SIZE, Grid.TILE_SIZE)
	tile_set.add_source(source, 0)
	var half := Grid.TILE_SIZE * 0.5
	var square := PackedVector2Array([Vector2(-half, -half), Vector2(half, -half), Vector2(half, half), Vector2(-half, half)])
	for tile: int in Tile.values():
		source.create_tile(Vector2i(tile, 0))
		if tile in SOLID_TILES:
			var data := source.get_tile_data(Vector2i(tile, 0), 0)
			data.add_collision_polygon(0)
			data.set_collision_polygon_points(0, 0, square)
	return tile_set


func _paint_layout() -> void:
	if layout.size() != Grid.ROOM_TILES.y:
		push_error("Room layout must have %d rows, has %d" % [Grid.ROOM_TILES.y, layout.size()])
	for y: int in layout.size():
		var row := layout[y]
		if row.length() != Grid.ROOM_TILES.x:
			push_error("Room layout row %d must be %d wide" % [y, Grid.ROOM_TILES.x])
		for x: int in row.length():
			var tile: Tile = LEGEND.get(row[x], Tile.FLOOR)
			tiles.set_cell(Vector2i(x, y), 0, Vector2i(tile, 0))


## One closed door in the middle of each wall (visual only until task 005).
func _place_doors() -> void:
	var size := Vector2(Grid.ROOM_TILES * Grid.TILE_SIZE)
	var half := Grid.TILE_SIZE * 0.5
	var doors: Array[Array] = [
		[Vector2(size.x * 0.5, half), 0.0],
		[Vector2(size.x - half, size.y * 0.5), PI * 0.5],
		[Vector2(size.x * 0.5, size.y - half), PI],
		[Vector2(half, size.y * 0.5), PI * 1.5],
	]
	for door: Array in doors:
		var sprite := Sprite2D.new()
		sprite.texture = TILES_TEXTURE
		sprite.region_enabled = true
		sprite.region_rect = Rect2(Tile.DOOR * Grid.TILE_SIZE, 0, Grid.TILE_SIZE, Grid.TILE_SIZE)
		sprite.position = door[0]
		sprite.rotation = door[1]
		sprite.name = "Door%d" % get_child_count()
		add_child(sprite)
		move_child(sprite, tiles.get_index() + 1)
