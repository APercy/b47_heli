local S = ap_heli.S

if not minetest.settings:get_bool('ap_heli.disable_craftitems') then
    -- wing
    minetest.register_craftitem("heli:rotor",{
	    description = S("B47 Helicopter rotor"),
	    inventory_image = "heli_b47_rotor_ico.png",
    })
-- fuselage
    minetest.register_craftitem("heli:fuselage",{
	    description = S("B47 Helicopter fuselage"),
	    inventory_image = "heli_b47_fuselage_ico.png",
    })
end

-- pa28
minetest.register_craftitem("heli:heli", {
	description = S("B47 Helicopter"),
	inventory_image = "heli_b47_ico_inv.png",
    liquids_pointable = false,

	on_place = function(itemstack, placer, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
        
        local pointed_pos = pointed_thing.under
        --local node_below = minetest.get_node(pointed_pos).name
        --local nodedef = minetest.registered_nodes[node_below]
        
		pointed_pos.y=pointed_pos.y+0.5
		local heli_ent = minetest.add_entity(pointed_pos, "heli:heli")
		if heli_ent and placer then
            local ent = heli_ent:get_luaentity()
            if ent then
                local owner = placer:get_player_name()
                ent.owner = owner
			    heli_ent:set_yaw(placer:get_look_horizontal())
			    itemstack:take_item()
                airutils.create_inventory(ent, ent._trunk_slots, owner)
            end
		end

		return itemstack
	end,
})

--
-- crafting
--

if not minetest.settings:get_bool('ap_heli.disable_craftitems') and minetest.get_modpath("default") then
    minetest.register_craft({
	    output = "heli:rotor",
	    recipe = {
		    {"default:tin_ingot", "", "default:tin_ingot"},
		    {"default:steel_ingot", "default:tinblock", "default:steel_ingot"},
	    }
    })

    minetest.register_craft({
	    output = "heli:fuselage",
	    recipe = {
		    {"default:glass", "default:diamondblock", "default:tin_ingot"},
		    {"default:glass", "default:steel_ingot",  "default:steel_ingot"},
		    {"default:tin_ingot", "default:mese_block",   "default:tin_ingot"},
	    }
    })

	minetest.register_craft({
		output = "heli:heli",
		recipe = {
			{"heli:rotor",},
			{"heli:fuselage",},
		}
	})
end

