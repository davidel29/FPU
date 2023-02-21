#ifndef FPU_FLOAT_IEEE_754_H
#define FPU_FLOAT_IEEE_754_H

typedef union {
    float value;
    struct
    {
        unsigned int mantissa : 23;
        unsigned int exponent : 8;
        unsigned int sign : 1;
    };
}float_ieee_754;

#endif //FPU_FLOAT_IEEE_754_H
