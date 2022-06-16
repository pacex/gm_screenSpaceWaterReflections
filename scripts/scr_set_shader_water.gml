///scr_set_shader_water(depth, albedo)

shader_set(sh_water);

shader_set_uniform_f(shader_get_uniform(sh_water, "time"), current_time);
shader_set_uniform_f(shader_get_uniform(sh_water, "cameraFar"), 4096);
shader_set_uniform_f_array(shader_get_uniform(sh_water, "lightDirection"), light_direction);
shader_set_uniform_matrix_array(shader_get_uniform(sh_water, "InvView"), MATRIX_INV_VIEW);
shader_set_uniform_matrix_array(shader_get_uniform(sh_water, "ProjView"), MATRIX_PROJ_VIEW);

if (surface_exists(argument0)){
    texture_set_stage(shader_get_sampler_index(sh_water, "depth"), surface_get_texture(argument0));
}
if (surface_exists(argument1)){
    texture_set_stage(shader_get_sampler_index(sh_water, "albedo"), surface_get_texture(argument1));
}
