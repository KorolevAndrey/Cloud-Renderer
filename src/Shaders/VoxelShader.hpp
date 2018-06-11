#pragma once
#ifndef _VOXEL_SHADER_HPP_
#define _VOXEL_SHADER_HPP_

#include "Shader.hpp"
#include "CloudVolume.hpp"

#include <vector>

class Mesh;
class VoxelShader : public Shader {
    public:
        VoxelShader(int count, const std::string &r, const std::string &v, const std::string &f);

        void render(const CloudVolume *, const glm::mat4 &, const glm::mat4 &);

        bool useOutline = true;
        bool disableBounds = false;
        bool disableWhite = false;
        bool disableBlack = false;
        float alpha = 1.f;

    private:
        /* Instanced cube mesh data */
        Mesh * cube;
        GLuint cubePositionVBO;
        GLuint cubeDataVBO;
};

#endif