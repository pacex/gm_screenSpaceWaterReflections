//
// Simple passthrough vertex shader
//
attribute vec3 in_Position;                  // (x,y,z)
//attribute vec3 in_Normal;                  // (x,y,z)     unused in this shader.
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec4 v_vWorldPosition;
varying vec4 v_vProjPosition;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    v_vProjPosition = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vWorldPosition = gm_Matrices[MATRIX_WORLD] * object_space_pos;
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~varying vec2 v_vTexcoord;
varying vec4 v_vColour;
varying vec4 v_vWorldPosition;
varying vec4 v_vProjPosition;

uniform sampler2D depth;
uniform sampler2D albedo;

uniform float time;
uniform float cameraFar;
uniform vec3 lightDirection;
uniform mat4 InvView;
uniform mat4 ProjView;

float unpackDepth(vec4 col){
    if (col.a < 1.0){
        return 999999999.0;
    }
    return col.x + col.y / 255.0 + col.z / 255.0 / 255.0;
}

bool isOccluded(vec4 worldSpacePos){
    vec4 projSpacePos = ProjView * worldSpacePos;
    float pointDepth = projSpacePos.z / cameraFar;
    vec2 screenPos = (projSpacePos / projSpacePos.w).xy * 0.5 + vec2(0.5);
    screenPos.y = 1.0 - screenPos.y;
    
    if(screenPos.x < 0.0 || screenPos.x >= 1.0 || screenPos.y < 0.0 || screenPos.y >= 1.0){
        return true;
    }
    
    return unpackDepth(texture2D(depth, screenPos)) < pointDepth;
}

void main()
{
    vec3 camPos = (InvView * vec4(0.0, 0.0, 0.0, 1.0)).xyz;

    /* Retrieve normals from noise texture */
    vec4 ncol1 = texture2D(gm_BaseTexture, v_vTexcoord + time * vec2(0.02, -0.04) * 0.004);
    vec4 ncol2 = texture2D(gm_BaseTexture, 1.07 * v_vTexcoord + time * vec2(-0.03, -0.01) * 0.004);
    
    vec4 ncol = mix(ncol1, ncol2, 0.5);
    
    
    vec3 normal = normalize(2.0 * ncol.xyz - vec3(1.0));
    normal.x *= 0.8;
    normal.y *= 0.8;
    normal = normalize(normal);
    
    /* Mix base color */
    vec2 screenPos = (v_vProjPosition / v_vProjPosition.w).xy * 0.5 + vec2(0.5);
    screenPos.y = 1.0 - screenPos.y;
    
    float alpha = mix(1.0, 1.0 - pow(abs(dot(normalize(camPos - v_vWorldPosition.xyz), normal)), 0.5), 0.4);

    vec4 baseColor = vec4(0.388, 0.529, 0.945, 1.0);
    
        /* Screen space reflection */
    vec3 reflectVector = normalize(reflect(v_vWorldPosition.xyz - camPos, normal));
    vec4 reflectColor;
    
    float maxDist = 4096.0;
    float dist = maxDist;
    float minInterval = 8.0;
    float interval = maxDist;
    vec3 currentPos = v_vWorldPosition.xyz + dist * reflectVector;
    while(interval >= minInterval){
        
        interval *= 0.5;
    
        if(isOccluded(vec4(currentPos, 1.0))){
            dist -= interval;
        }else{
            dist += interval;
        }
        
        currentPos = v_vWorldPosition.xyz + dist * reflectVector;  
    }
    
    vec4 reflectPosProjSpace = ProjView * vec4(currentPos, 1.0);
    vec2 reflectPosScreenSpace = (reflectPosProjSpace / reflectPosProjSpace.w).xy * 0.5 + vec2(0.5);
    reflectPosScreenSpace.y = 1.0 - reflectPosScreenSpace.y;
    
    if(reflectPosScreenSpace.x < 0.0 || reflectPosScreenSpace.x >= 1.0 || reflectPosScreenSpace.y < 0.0 || reflectPosScreenSpace.y >= 1.0 || reflectPosProjSpace.z < 100.0){
        reflectColor = baseColor;
    }else{
        reflectColor = mix(texture2D(albedo, reflectPosScreenSpace), baseColor,
        pow(2.0 * abs(reflectPosScreenSpace.x - 0.5), 3.0));
    }
    
    baseColor = mix(baseColor, reflectColor, 0.8);
    
    vec4 backgroundColor = texture2D(albedo, vec2(clamp(screenPos.x + normal.x * 0.04, 0.0, 1.0), clamp(screenPos.y + normal.y * 0.04, 0.0, 1.0)));
    
    vec4 Color = mix(backgroundColor, baseColor, alpha);
    
    /* Lighting */
    gl_FragColor = vec4(Color.xyz * mix(1.0, abs(dot(normal, -normalize(lightDirection))), 0.5), 1.0) // Diffuse
    + vec4(1.0, 1.0, 1.0, 0.0) * pow(abs(dot(normal, normalize(-normalize(lightDirection) + normalize(camPos - v_vWorldPosition.xyz)))), 400.0); // Specular
    
}

