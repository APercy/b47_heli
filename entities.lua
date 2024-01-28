
--
-- entity
--

ap_heli.vector_up = vector.new(0, 1, 0)

minetest.register_entity('heli:heli',
    airutils.properties_copy(ap_heli.plane_properties)
)

