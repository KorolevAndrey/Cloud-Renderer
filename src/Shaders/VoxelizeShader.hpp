#pragma once
#ifndef _VOXELIZE_SHADER_HPP_
#define _VOXELIZE_SHADER_HPP_

#include "Shader.hpp"

#include "Model/Texture.hpp"
#include "Volume.hpp"

class VoxelizeShader : public Shader {
    public:
        VoxelizeShader(std::string, std::string);
            
        enum Stage {
            Voxelize,   // 0
            Positions,  // 1 
        };

        /* Generic function to render quad -- takes Stage as a parameter to orchestrate GL binds */
        void renderQuad(glm::vec3, Spatial, glm::mat4, glm::mat4, glm::vec3, VoxelizeShader::Stage);

        /* Generate 3D volume */
        void voxelize(Volume *);

        /* 2D position texture */
        Texture * positionMap;
        void clearPositionMap();

    private:
        void bindVolume(Volume *);
        void unbindVolume();

        void initPositionMap(int, int);
        void bindPositionMap();
        void unbindPositionMap();
};

#endif