#ifndef FPU_FPU_H
#define FPU_FPU_H

#include "Binary_operations.h"
#include "float_ieee_754.h"

class FPU {

private:
    Binary_operations binary_operations;
    const int size_intermediate_mantissa = 24;
    float_ieee_754 f_out;
    int intermediate_mantissa_1;
    int intermediate_mantissa_2;
    int intermediate_mantissa_out;
    vector<bool> v_intermediate_mantissa_1;
    vector<bool> v_intermediate_mantissa_2;
    vector<bool> v_intermediate_mantissa_out;
    void align_mantissas(float_ieee_754 f1, float_ieee_754 f2);
    void normalize();

public:
    FPU();
    float_ieee_754 multiplication(float_ieee_754 f1, float_ieee_754 f2);
    float_ieee_754 division(float_ieee_754 f1, float_ieee_754 f2);
    float_ieee_754 addition(float_ieee_754 f1, float_ieee_754 f2);
    float_ieee_754 subtraction(float_ieee_754 f1, float_ieee_754 f2);
};

#endif //FPU_FPU_H
