#include "FPU.h"

FPU::FPU(){}

float_ieee_754 FPU::multiplication(float_ieee_754 f1, float_ieee_754 f2) {
    //exponent
    f_out.exponent = f1.exponent + f2.exponent - 127;
    //vectorisation of mantissas
    v_intermediate_mantissa_1.resize(size_intermediate_mantissa);
    v_intermediate_mantissa_2.resize(size_intermediate_mantissa);
    for(int i = 0; i < size_intermediate_mantissa; i++){
        v_intermediate_mantissa_1[i] = (f1.mantissa | (1 << (size_intermediate_mantissa - 1))) & ( 1 << i);
        v_intermediate_mantissa_2[i] = (f2.mantissa | (1 << (size_intermediate_mantissa - 1))) & ( 1 << i);
    }
    //binary multiplication of mantissas
    v_intermediate_mantissa_out = binary_operations.multiplication(v_intermediate_mantissa_1, v_intermediate_mantissa_2);
    //normalize
    f_out.mantissa = 0;
    if(v_intermediate_mantissa_out[2 * size_intermediate_mantissa - 1]){
        f_out.exponent++;
        for(int i = size_intermediate_mantissa; i < (2*size_intermediate_mantissa - 1); i++){
            f_out.mantissa += v_intermediate_mantissa_out[i] << (i - size_intermediate_mantissa);
        }
        if(v_intermediate_mantissa_out[size_intermediate_mantissa - 1]){
            f_out.mantissa++;
        }
    }else{
        for(int i = (size_intermediate_mantissa - 1); i < (2*size_intermediate_mantissa - 2); i++){
            f_out.mantissa += v_intermediate_mantissa_out[i] << (i - (size_intermediate_mantissa - 1));
        }
        if(v_intermediate_mantissa_out[size_intermediate_mantissa - 2]){
            f_out.mantissa++;
        }
    }
    //sign
    f_out.sign = f1.sign ^ f2.sign;
    return f_out;
}

float_ieee_754 FPU::division(float_ieee_754 f1, float_ieee_754 f2) {
    float_ieee_754 theory;
    theory.value = f1.value/f2.value;
    //exponent
    f_out.exponent = f1.exponent - f2.exponent + 127;
    //vectorisation of mantissas
    v_intermediate_mantissa_1.resize(size_intermediate_mantissa * 2 - 1);
    v_intermediate_mantissa_2.resize(size_intermediate_mantissa * 2 - 1);
    for(int i = 0; i < size_intermediate_mantissa; i++){
        v_intermediate_mantissa_1[i + size_intermediate_mantissa - 1] = (f1.mantissa | (1 << (size_intermediate_mantissa - 1))) & ( 1 << i);
        v_intermediate_mantissa_2[i] = (f2.mantissa | (1 << (size_intermediate_mantissa - 1))) & ( 1 << i);
    }
    //binary division of mantissas
    v_intermediate_mantissa_out = binary_operations.division(v_intermediate_mantissa_1, v_intermediate_mantissa_2);
    //normalize
    f_out.mantissa = 0;
    if(v_intermediate_mantissa_out[size_intermediate_mantissa - 1]){
        for(int i = 0; i < size_intermediate_mantissa - 1; i++){
            f_out.mantissa += v_intermediate_mantissa_out[i] << i;
        }
    }else{
        for(int i = 0; i < size_intermediate_mantissa - 1; i++){
            f_out.mantissa += v_intermediate_mantissa_out[i] << (i + 1);
        }
        f_out.exponent--;
    }
    //sign
    f_out.sign = f1.sign ^ f2.sign;
    return f_out;
}

float_ieee_754 FPU::addition(float_ieee_754 f1, float_ieee_754 f2) {
    //float the decimal point from the smallest to the largest exponent
    align_mantissas(f1, f2);
    //addition or subtraction of mantissas according to the signs
    if(f1.sign == f2.sign){
        intermediate_mantissa_out = intermediate_mantissa_1 + intermediate_mantissa_2;
        f_out.sign = f1.sign;
    }else if((f1.sign == 0) && (f2.sign == 1)){
        if(intermediate_mantissa_1 > intermediate_mantissa_2){
            intermediate_mantissa_out = intermediate_mantissa_1 - intermediate_mantissa_2;
            f_out.sign = f1.sign;
        }else{
            intermediate_mantissa_out = intermediate_mantissa_2 - intermediate_mantissa_1;
            f_out.sign = f2.sign;
        }
    }else if((f1.sign == 1) && (f2.sign == 0)){
        if(intermediate_mantissa_1 < intermediate_mantissa_2){
            intermediate_mantissa_out = intermediate_mantissa_2 - intermediate_mantissa_1;
            f_out.sign = f2.sign;
        }else{
            intermediate_mantissa_out = intermediate_mantissa_1 - intermediate_mantissa_2;
            f_out.sign = f1.sign;
        }
    }
    //normalize
    normalize();
    return f_out;
}

float_ieee_754 FPU::subtraction(float_ieee_754 f1, float_ieee_754 f2) {
    //float the decimal point from the smallest to the largest exponent
    align_mantissas(f1, f2);
    //addition or subtraction of mantissas according to the signs
    if(f1.sign != f2.sign){
        intermediate_mantissa_out = intermediate_mantissa_1 + intermediate_mantissa_2;
        f_out.sign = f1.sign;
    }else if((f1.sign == 0) && (f2.sign == 0)){
        if(intermediate_mantissa_1 > intermediate_mantissa_2){
            intermediate_mantissa_out = intermediate_mantissa_1 - intermediate_mantissa_2;
            f_out.sign = f1.sign;
        }else{
            intermediate_mantissa_out = intermediate_mantissa_2 - intermediate_mantissa_1;
            f_out.sign = 1;
        }
    }else if((f1.sign == 1) && (f2.sign == 1)){
        if(intermediate_mantissa_1 < intermediate_mantissa_2){
            intermediate_mantissa_out = intermediate_mantissa_2 - intermediate_mantissa_1;
            f_out.sign = 0;
        }else{
            intermediate_mantissa_out = intermediate_mantissa_1 - intermediate_mantissa_2;
            f_out.sign = f1.sign;
        }
    }
    //normalize
    normalize();
    return f_out;
}

void FPU::align_mantissas(float_ieee_754 f1, float_ieee_754 f2) {
    //mantissa + hidden bit
    intermediate_mantissa_1 = f1.mantissa | (1 << (size_intermediate_mantissa - 1));
    intermediate_mantissa_2 = f2.mantissa | (1 << (size_intermediate_mantissa - 1));
    //float the decimal point from the smallest to the largest exponent
    if(f1.exponent > f2.exponent){
        intermediate_mantissa_2 = intermediate_mantissa_2 >> (f1.exponent - f2.exponent);
        f_out.exponent = f1.exponent;
    }else if(f1.exponent < f2.exponent){
        intermediate_mantissa_1 = intermediate_mantissa_1 >> (f2.exponent - f1.exponent);
        f_out.exponent = f2.exponent;
    }else{
        f_out.exponent = f1.exponent;
    }
}

void FPU::normalize() {
    f_out.mantissa = 0;
    //shift right
    if(intermediate_mantissa_out & (1 << size_intermediate_mantissa)){
        f_out.mantissa = (intermediate_mantissa_out >> 1);
        f_out.exponent++;
        //if(intermediate_mantissa_out & 0x1){
            //f_out.mantissa++;
        //}
    //no operation
    }else if(intermediate_mantissa_out & (1 << (size_intermediate_mantissa - 1))){
        f_out.mantissa = intermediate_mantissa_out;
    //shift left until find 1
    }else{
        for(int i = (size_intermediate_mantissa - 2); i >= 0; i--){
            if(intermediate_mantissa_out & (1 << i)){
                f_out.mantissa = (intermediate_mantissa_out << ((size_intermediate_mantissa - 1) - i));
                f_out.exponent -= ((size_intermediate_mantissa - 1) - i);
                break;
            }
        }
    }
}
