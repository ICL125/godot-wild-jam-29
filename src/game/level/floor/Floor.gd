extends TileMap


var name_to_id_mapping = {}
var id_to_name_mapping = {}

var floor_borders = {}

func _ready():
	var ids = tile_set.get_tiles_ids()
	for id in ids:
		var tile_name = tile_set.tile_get_name(id)
		name_to_id_mapping[tile_name] = id
		id_to_name_mapping[id] = tile_name
	print(name_to_id_mapping)
	print(id_to_name_mapping)
	print(collision_mask)
	print(collision_layer)
	
func add_border(cell: Vector2, direction: String):
	if not floor_borders.has(cell):
		floor_borders[cell] = {
			"sw": false,
			"se": false,
			"nw": false,
			"ne": false,
		}
		
	floor_borders[cell][direction] = true

func activate_borders():
	for floor_border in floor_borders:
		# directions are found as in which direction they are experienced, not from the border's perspective!
		var bordering_directions = floor_borders[floor_border]
		if bordering_directions.nw and bordering_directions.ne:
			set_cellv(floor_border, name_to_id_mapping["collision_s"])
		elif bordering_directions.nw:
			set_cellv(floor_border, name_to_id_mapping["collision_nw"])
		elif bordering_directions.ne:
			set_cellv(floor_border, name_to_id_mapping["collision_ne"])
			
func activate():
#	show()
	collision_layer = 1
	collision_mask = 1
			
func deactivate():
	collision_layer = 2
	collision_mask = 2147483650
#	hide()
	
func clean():
	var used_cells = {}
	for cellv in get_used_cells():
		used_cells[cellv] = get_cellv(cellv)
	
	for used_cell in used_cells.keys():
		var cell_name: String = id_to_name_mapping[used_cells[used_cell]]
		var nw = used_cell + Vector2(-1, 0)
		var ne = used_cell + Vector2(0, -1)
		var sw = used_cell + Vector2(0, 1)
		var se = used_cell + Vector2(1, 0)
		var nw_exists = used_cells.has(nw)
		var ne_exists = used_cells.has(ne)
		var sw_exists = used_cells.has(sw)
		var se_exists = used_cells.has(se)
		if cell_name.begins_with("floor"):
			if !sw_exists:
				add_border(sw, "sw")
			if !nw_exists:
				add_border(nw, "nw")
			if !ne_exists:
				add_border(ne, "ne")
			if !se_exists:
				add_border(se, "se")
				
			if !sw_exists and !se_exists:
				set_cellv(used_cell, name_to_id_mapping["floor_half"])
			elif !sw_exists:
				if used_cells.has(used_cell + Vector2(1, 1)) and id_to_name_mapping[used_cells[used_cell + Vector2(1, 1)]].begins_with("floor"):
					set_cellv(used_cell, name_to_id_mapping["floor_half_left_obstructed"])
				elif used_cells.has(used_cell + Vector2(1, 1)) and id_to_name_mapping[used_cells[used_cell + Vector2(1, 1)]] == "slope_sw":
					set_cellv(used_cell, name_to_id_mapping["floor_half_left_obstructed_slope"])
				else:
					set_cellv(used_cell, name_to_id_mapping["floor_half_left"])
			elif !se_exists:
				if used_cells.has(used_cell + Vector2(1, 1)) and id_to_name_mapping[used_cells[used_cell + Vector2(1, 1)]].begins_with("floor"):
					set_cellv(used_cell, name_to_id_mapping["floor_half_right_obstructed"])
				elif used_cells.has(used_cell + Vector2(1, 1)) and id_to_name_mapping[used_cells[used_cell + Vector2(1, 1)]] == "slope_se":
					set_cellv(used_cell, name_to_id_mapping["floor_half_right_obstructed_slope"])
				else:
					set_cellv(used_cell, name_to_id_mapping["floor_half_right"])
				
			elif sw_exists and id_to_name_mapping[used_cells[sw]].begins_with("slope_nw"):
					set_cellv(used_cell, name_to_id_mapping["floor_half_left_slope_nw"])
			elif se_exists and id_to_name_mapping[used_cells[se]].begins_with("slope_ne"):
					set_cellv(used_cell, name_to_id_mapping["floor_half_right_slope_ne"])
			else:
				set_cellv(used_cell, name_to_id_mapping["floor"])
				
				
		if cell_name.begins_with("slope"):
			if cell_name.begins_with("slope_sw"):
				if se_exists:
					set_cellv(used_cell, name_to_id_mapping["slope_sw_obstructed"])
					if nw_exists and id_to_name_mapping[used_cells[nw]].begins_with("slope_sw"):
						set_cellv(used_cell, name_to_id_mapping["slope_sw_obstructed_middle"])
				else:
					if nw_exists and id_to_name_mapping[used_cells[nw]].begins_with("slope_sw"):
						set_cellv(used_cell, name_to_id_mapping["slope_sw_begin"])
			if cell_name.begins_with("slope_se"):
				if sw_exists:
					set_cellv(used_cell, name_to_id_mapping["slope_se_obstructed"])
					if ne_exists and id_to_name_mapping[used_cells[ne]].begins_with("slope_se"):
						set_cellv(used_cell, name_to_id_mapping["slope_se_obstructed_middle"])
				else:
					if ne_exists and id_to_name_mapping[used_cells[ne]].begins_with("slope_se"):
						set_cellv(used_cell, name_to_id_mapping["slope_se_begin"])
			if cell_name.begins_with("slope_nw"):
				if sw_exists:
					set_cellv(used_cell, name_to_id_mapping["slope_nw_obstructed"])
					if ne_exists and id_to_name_mapping[used_cells[ne]].begins_with("slope_nw"):
						set_cellv(used_cell, name_to_id_mapping["slope_nw_obstructed_middle"])
				else:
					if used_cells.has(sw + Vector2(1, 0)) and id_to_name_mapping[used_cells[sw + Vector2(1, 0)]].begins_with("floor"):
						set_cellv(used_cell, name_to_id_mapping["slope_nw_half_obstructed"])
						if ne_exists and id_to_name_mapping[used_cells[ne]].begins_with("slope_nw"):
							set_cellv(used_cell, name_to_id_mapping["slope_nw_half_obstructed_begin"])
					else:
						set_cellv(used_cell, name_to_id_mapping["slope_nw"])
						if ne_exists and id_to_name_mapping[used_cells[ne]].begins_with("slope_nw"):
							set_cellv(used_cell, name_to_id_mapping["slope_nw_begin"])
			if cell_name.begins_with("slope_ne"):
				if se_exists:
					set_cellv(used_cell, name_to_id_mapping["slope_ne_obstructed"])
					if nw_exists and id_to_name_mapping[used_cells[nw]].begins_with("slope_ne"):
						set_cellv(used_cell, name_to_id_mapping["slope_ne_obstructed_middle"])
				else:
					if used_cells.has(se + Vector2(0, 1)) and id_to_name_mapping[used_cells[se + Vector2(0, 1)]].begins_with("floor"):
						set_cellv(used_cell, name_to_id_mapping["slope_ne_half_obstructed"])
						if nw_exists and id_to_name_mapping[used_cells[nw]].begins_with("slope_ne"):
							set_cellv(used_cell, name_to_id_mapping["slope_ne_half_obstructed_begin"])
					else:
						set_cellv(used_cell, name_to_id_mapping["slope_ne"])
						if nw_exists and id_to_name_mapping[used_cells[nw]].begins_with("slope_ne"):
							set_cellv(used_cell, name_to_id_mapping["slope_ne_begin"])
