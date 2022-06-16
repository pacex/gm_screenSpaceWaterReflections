/* DEPTH SHADER
    writes depth values onto the surface
*/

attribute vec3 in_Position;
attribute vec2 in_Texcoords;

varying float linearizedDepth;
varying vec2 v_vTexcoords;

uniform float uCameraFar;
uniform float uCameraNear;

void main() {
    vec4 object_space_pos = vec4(in_Position,1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;

    linearizedDepth = gl_Position.z / uCameraFar;
    v_vTexcoords = in_Texcoords;
}
//######################_==_YOYO_SHADER_MARKER_==_######################@~varying float linearizedDepth;
varying vec2 v_vTexcoords;

//Write floating point depth as color onto depth map surface
vec3 packDepth(float f) {
    return vec3( floor( f * 255.0 ) / 255.0, fract( f * 255.0 ), fract( f * 255.0 * 255.0 ) );
}

void main() {        
    float depth = linearizedDepth;//unlinearizeDepth( linearizedDepth );
    gl_FragColor = vec4( packDepth(depth), 1.0 );
    //gl_FragColor = vec4( depth, depth, depth, 1.0 );

}
