#version 330 core
layout(location = 0) in vec3 vertPos;

uniform mat4 P;
uniform mat4 M;
uniform mat4 V;

uniform vec3 center;
uniform vec2 size;

out vec3 worldPos;
out vec2 fragTex;

void main() {
    vec3 cameraRight = vec3(V[0][0], V[1][0], V[2][0]);
    vec3 cameraUp = vec3(V[0][1], V[1][1], V[2][1]);
    vec4 rotatedPos = M * vec4(vertPos, 1.0);
    worldPos = 
        center
        + cameraRight * rotatedPos.x * size.x
        + cameraUp * rotatedPos.y * size.y;
    gl_Position = P * V * vec4(worldPos, 1.0);
    fragTex = (vertPos.xy + 1.0) / 2.0;

}