ap_heli={}

function ap_heli.register_parts_method(self)
    local pos = self.object:get_pos()

    --[[local lights=minetest.add_entity(pos,'heli:p_lights')
    lights:set_attach(self.object,'',{x=0,y=0,z=0},{x=0,y=0,z=0})
    self.lights = lights

    local light=minetest.add_entity(pos,'heli:light')
    light:set_attach(self.object,'',{x=0,y=0,z=0},{x=0,y=0,z=0})
    self.light = light]]--

    --minetest.chat_send_all(self.initial_properties.textures[19])
    --airutils.paint(self.wheels:get_luaentity(), self._color)
end

function ap_heli.destroy_parts_method(self)
    if self.wheels then self.wheels:remove() end
    if self.light then self.light:remove() end
    if self.lights then self.lights:remove() end

    local pos = self.object:get_pos()
    if not minetest.settings:get_bool('ap_heli.disable_craftitems') then
        pos.y=pos.y+2
        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'heli:rotor')

        for i=1,2 do
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:tin_ingot')
        end

        for i=1,6 do
	        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:mese_crystal')
            minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'default:diamond')
        end
    else
        minetest.add_item({x=pos.x+math.random()-0.5,y=pos.y,z=pos.z+math.random()-0.5},'heli:heli')
    end
end

function ap_heli.step_additional_function(self)
    --position lights
    --[[
    if self._land_light == true then
        self.light:set_properties({textures={"pa28_landing_light.png"},glow=15})
    else
        self.light:set_properties({textures={"pa28_metal.png"},glow=0})
    end]]--

    if (self.driver_name==nil) and (self.co_pilot==nil) then --pilot or copilot
        return
    end

    local pos = self._curr_pos

    local climb_angle = airutils.get_gauge_angle(self._climb_rate)
    self.object:set_bone_position("climber", {x=2.401,y=12.8818,z=19.60}, {x=0,y=0,z=climb_angle-90})

    local energy_indicator_angle = airutils.get_gauge_angle((self._max_fuel - self._energy)/1) - 90
    self.object:set_bone_position("fuel_i", {x=0.671428, y=11.4485, z=19.60}, {x=0,y=0,z=-energy_indicator_angle+180})

    --altimeter
    local altitude = (pos.y / 0.32) / 100
    local hour, minutes = math.modf( altitude )
    hour = math.fmod (hour, 10)
    minutes = minutes * 100
    minutes = (minutes * 100) / 100
    local minute_angle = (minutes*-360)/100
    local hour_angle = (hour*-360)/10 + ((minute_angle*36)/360)
    self.object:set_bone_position("altimeter_pt_1", {x=-1.35246, y=12.8837 , z=19.60}, {x=0, y=0, z=(hour_angle)})
    self.object:set_bone_position("altimeter_pt_2", {x=-1.35246, y=12.8837 , z=19.60}, {x=0, y=0, z=(minute_angle)})

    --set stick position
    --[[local stick_z = 9 + (self._elevator_angle / self._elevator_limit )
    self.object:set_bone_position("stick.l", {x=-4.25, y=0.5, z=stick_z}, {x=0,y=0,z=self._rudder_angle})
    self.object:set_bone_position("stick.r", {x=4.25, y=0.5, z=stick_z}, {x=0,y=0,z=self._rudder_angle})]]--
end

ap_heli.plane_properties = {
	initial_properties = {
	    physical = true,
        collide_with_objects = true,
	    collisionbox = {-1.2, 0, -1.2, 1.2, 2, 1.2},
	    selectionbox = {-2, 0, -2, 2, 2, 2},
	    visual = "mesh",
        backface_culling = false,
	    mesh = "b47_heli.b3d",
        stepheight = 0.5,
        textures = {
            "airutils_painting.png", --cabine
            "airutils_metal.png", --motor
            "airutils_black2.png", --redução motor
            "airutils_painting.png", --tanques
            "airutils_painting_2.png", --estrutura empenagem
            "heli_b47_glass.png", --parabrisa
            "airutils_painting.png", --estabilizador horizontal
            "airutils_black.png", --interior
            "airutils_painting.png", --nacele rotor traseiro
            "airutils_black2.png", --eixo rotor traseiro
            "heli_b47_tail_rotor.png", --pas rotor traseiro
            "airutils_painting_2.png", --pintura eixo rotor principal
            "heli_b47_rotor.png", --rotor principal
            "airutils_white.png", --ponteiros
            "airutils_black.png", --assentos
            "heli_b47_panel.png", --painel de instrumentos
            "airutils_painting_2.png", --pintura ski
            "airutils_black2.png", --tampas cabeçotes
            "airutils_painting.png", --estabilizador vertical
        },
    },
    textures = {},
    _anim_frames = 12,
	driver_name = nil,
	sound_handle = nil,
    owner = "",
    static_save = true,
    infotext = "",
    hp_max = 50,
    shaded = true,
    show_on_minimap = true,
    springiness = 0.1,
    buoyancy = 1.02,
    physics = airutils.physics, --airutils.physics_floating,
    _vehicle_name = "B47 Helicopter",
    _seats = {{x=-4.2,y=9.5,z=10.52},{x=4.2,y=9.5,z=10.52},},
    _seats_rot = {0, 0, 0, 0},  --necessary when using reversed seats
    _have_copilot = true, --wil use the second position of the _seats list
    _have_landing_lights = false,
    _have_auto_pilot = false,
    _have_adf = false,
    _max_plane_hp = 50,
    _enable_fire_explosion = true,
    _longit_drag_factor = 0.01*0.01,
    _later_drag_factor = 0.01*0.01,
    _wing_angle_of_attack = 1.2,
    _wing_span = 10, --meters
    _min_speed = 0,
    _max_speed = 10,
    _max_fuel = 10,
    _speed_not_exceed = 32,
    _damage_by_wind_speed = 2,
    _hard_damage = true,
    _min_attack_angle = 0.2,
    _max_attack_angle = 90,
    _tail_lift_min_speed = 0,
    _tail_lift_max_speed = 0,
    _max_engine_acc = 20.0,
    _tail_angle = 0,
    _lift = 11,
    _trunk_slots = 8, --the trunk slots
    _rudder_limit = 40.0,
    _elevator_limit = 15.0,
    _elevator_response_attenuation = 4,
    _pitch_intensity = 0.4,
    _yaw_intensity = 20,
    _yaw_turn_rate = 14, --degrees
    _elevator_pos = {x=0, y=2.5, z=-45},
    _rudder_pos = {x=0,y=0,z=0},
    _aileron_r_pos = {x=0,y=0,z=0},
    _aileron_l_pos = {x=0,y=0,z=0},
    _color = "#0063b0",
    _color_2 = "#9f9f9f",
    _rudder_angle = 0,
    _acceleration = 0,
    _engine_running = false,
    _angle_of_attack = 0,
    _elevator_angle = 0,
    _power_lever = 0,
    _last_applied_power = 0,
    _energy = 1.0,
    _last_vel = {x=0,y=0,z=0},
    _longit_speed = 0,
    _show_hud = false,
    _instruction_mode = false, --flag to intruction mode
    _command_is_given = false, --flag to mark the "owner" of the commands now
    _last_accell = {x=0,y=0,z=0},
    _last_time_command = 1,
    _inv = nil,
    _inv_id = "",
    _collision_sound = "airutils_collision", --the col sound
    _engine_sound = "airutils_heli_snd",
    _painting_texture = {"airutils_painting.png",}, --the texture to paint
    _painting_texture_2 = {"airutils_painting_2.png",}, --the texture to paint
    _mask_painting_associations = {},
    _register_parts_method = ap_heli.register_parts_method, --the method to register plane parts
    _destroy_parts_method = ap_heli.destroy_parts_method,
    _plane_y_offset_for_bullet = 1,
    _fuel_consumption_divisor = 200000,

    _yaw_by_mouse = true,
    _climb_speed = 4,
    _lift_dead_zone = 0.05,
    _ground_effect_ammount_percent = 0.01,
    _min_collective = 1.0,
    _stable_collective = 1.4028,
    _rotor_speed = 15,
    _rotor_idle_speed = 14.5,
    _tilt_angle = 8,
    --_custom_punch_when_attached = ww1_planes_lib._custom_punch_when_attached, --the method to execute click action inside the plane
    _custom_pilot_formspec = airutils.pilot_formspec,
    _custom_step_additional_function = ap_heli.step_additional_function,

    get_staticdata = airutils.get_staticdata,
    on_deactivate = airutils.on_deactivate,
    on_activate = airutils.on_activate,
    logic = airutils.logic_heli,
    on_step = airutils.on_step,
    on_punch = airutils.on_punch,
    on_rightclick = airutils.on_rightclick,
}

dofile(minetest.get_modpath("heli") .. DIR_DELIM .. "crafts.lua")
dofile(minetest.get_modpath("heli") .. DIR_DELIM .. "entities.lua")

--
-- items
--

settings = Settings(minetest.get_worldpath() .. "/ap_heli.conf")
local function fetch_setting(name)
    local sname = name
    return settings and settings:get(sname) or minetest.settings:get(sname)
end


