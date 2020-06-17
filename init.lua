acid = {}
acid.immediately = {}
acid.never		 = {}

-- Acid
minetest.register_node("acid:flowing", {
	description = "Acid flowing",
	inventory_image = minetest.inventorycube("acid_source.png"),
	drawtype = "flowingliquid",
	tiles = {"acid_source.png"},
	special_tiles = {
		{
			image="acid_flowing_animated.png",
			backface_culling=false,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
		},
		{
			image="acid_flowing_animated.png",
			backface_culling=true,
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.3}
		},
	},
	use_texture_alpha = true,
	paramtype = "light",
	light_source = 3,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "acid:flowing",
	liquid_alternative_source = "acid:source",
	liquid_viscosity = 6,
	liquid_renewable = false,
	damage_per_second = 1,
	post_effect_color = {a=200, r=255, g=255, b=0},
	groups = {liquid=2, not_in_creative_inventory=1, acid=1},
})

minetest.register_node("acid:source", {
	description = "Acid source",
	drawtype = "liquid",
	drop = "acid:source",
	tiles = {
		{name="acid_source_animated.png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0}}
	},
	special_tiles = {
		{
			name="acid_source_animated.png",
			animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=3.0},
			backface_culling = false,
		}
	},
	use_texture_alpha = true,
	paramtype = "light",
	light_source = 3,
	walkable = false,
	pointable = true,
	diggable = false,
	damage_per_second = 7*2,
	buildable_to = true,
	liquidtype = "source",
	liquid_alternative_flowing = "acid:flowing",
	liquid_alternative_source = "acid:source",
	liquid_viscosity = 6,
	liquid_renewable = false,
})

-- Acid stopped by water
minetest.register_abm({
	nodenames = {"group:acid","acid:source"},
	neighbors = {"group:water"},
	interval = 3,
	chance = 1,
	action = function(pos)
		minetest.remove_node(pos)
	end,
})

-- Receipe
minetest.register_craft({
	output = 'acid:source',
	recipe = {
		{'default:diamond', 'technic:uranium_ingot', 'default:diamond'},
		{'technic:uranium_ingot', 'bucket:bucket_water', 'technic:uranium_ingot'},
		{'default:diamond', 'technic:uranium_ingot', 'default:diamond'},
	}
})

-- Register functions
acid.register_immediate = function(itemstring)
	table.insert(acid.immediately,1,itemstring)
end

acid.found_in_table = function(tablet, itemstring)
	local i = false
	for k,v in ipairs(tablet) do
		if v == itemstring then
			i = true
			break
		end
	end
	return i
end

-- Registrations
acid.register_immediate("group:flowers")
acid.register_immediate("group:plant")
acid.register_immediate("group:sapling")
acid.register_immediate("group:leaves")
acid.register_immediate("group:flora")

-- ABM
minetest.register_abm({
	nodenames = acid.immediately,
	neighbors = {"group:acid"},
	interval = 1,
	chance = 1,
	action = function(pos)
		if not acid.found_in_table(acid.never,minetest.get_node(pos).name) then
			minetest.remove_node(pos)
		end
	end,
})
