#pragma once
#ifndef _CONE_TRACE_SHADER_HPP_
#define _CONE_TRACE_SHADER_HPP_

#include "Shader.hpp"
#include "Volume.hpp"

class ConeTraceShader : public Shader {
    public:
        ConeTraceShader(const std::string &r, const std::string &v, const std::string &f) :
            Shader(r, v, f)
        {
            genNoise(32);
        }

        void coneTrace(Volume *, float);

        /* Cone trace parameters */
        int vctSteps = 16;
        float vctConeAngle = 0.784398163f;
        float vctConeInitialHeight = 0.1f;
        float vctLodOffset = 0.1f;
        float vctDownScaling = 3.f;

        bool sort = true;

    private:
        void bindVolume(Volume *);
        void unbindVolume();


        void genNoise(int);
        GLuint TexNoise;
};

#endif