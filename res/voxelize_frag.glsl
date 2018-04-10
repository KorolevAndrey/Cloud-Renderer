#version 440 core

#extension GL_NV_gpu_shader5: enable
#extension GL_NV_shader_atomic_float: enable
#extension GL_NV_shader_atomic_fp16_vector: enable

#define FLT_MAX 3.402823466e+38

in vec3 fragPos;
in vec2 fragTex;

uniform vec3 camPos;

uniform vec3 center;
uniform float scale;

layout(binding=0, rgba16f) uniform image3D volume;
uniform vec2 xBounds;
uniform vec2 yBounds;
uniform vec2 zBounds;
uniform int dimension;
uniform bool voxelize;

uniform float normalStep;
uniform float visibilityContrib;

layout(binding=1, rgba32f) uniform image2D positionMap;
uniform int mapWidth;
uniform int mapHeight;

out vec4 color;

/* Linear map from aribtray box(?) in world space to 3D volume 
 * Voxel indices: [0, dimension - 1] */
ivec3 calculateVoxelIndex(vec3 pos) {
    float rangeX = xBounds.y - xBounds.x;
    float rangeY = yBounds.y - yBounds.x;
    float rangeZ = zBounds.y - zBounds.x;

	float x = dimension * ((pos.x - xBounds.x) / rangeX);
	float y = dimension * ((pos.y - yBounds.x) / rangeY);
	float z = dimension * ((pos.z - zBounds.x) / rangeZ);

	return ivec3(x, y, z);
}

void main() {
    float radius = scale/2;
    vec3 normal = normalize(camPos - center);

    /* 1 at center of billboard, 0 at edges */
    float distR = 1 - (distance(center, fragPos)/radius);
    color = vec4(distR);

    if(voxelize) {
        vec3 nearestPos = vec3(FLT_MAX, FLT_MAX, FLT_MAX);

        for(float j = -radius * distR; j < radius * distR; j += normalStep) {
            vec3 worldPos = fragPos + (normal * j);
            ivec3 voxelIndex = calculateVoxelIndex(worldPos);
            imageStore(volume, voxelIndex, vec4(worldPos, 1));

            if (distance(worldPos, camPos) < distance(nearestPos, camPos)) {
                nearestPos = worldPos;
            }
        }
        if (nearestPos.x != FLT_MAX) {
            imageStore(positionMap, ivec2(fragTex.x * mapWidth, fragTex.y * mapHeight), vec4(nearestPos, 1.0));
        }
    }

// #if GL_NV_shader_atomic_fp16_vector
//             imageAtomicAdd(volume, voxelIndex, f16vec4(0, 0, 0, visibilityContrib));
// #else
//             vec4 voxelData = imageLoad(volume, voxelIndex) + vec4(0, 0, 0, visibilityContrib);
//             imageStore(volume, voxelIndex, voxelData);
// #endif
}
