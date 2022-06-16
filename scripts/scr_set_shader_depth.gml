///scr_set_shader_depth();
shader_set(sh_depth);

shader_set_uniform_f(shader_get_uniform(sh_depth, "uCameraNear"), 1);
shader_set_uniform_f(shader_get_uniform(sh_depth, "uCameraFar"), 4096);
