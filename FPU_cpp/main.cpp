#include <iostream>
#include "float_ieee_754.h"
#include "FPU.h"

int main()
{
    //test bench binary operation
    Binary_operations binaryOperations;
    srand(time(nullptr));
    for (int j = 0; j < 50; j++){

        const int N = rand() % 32 + 1;
        const int M = rand() % 32 + 1;
        vector<bool> v1(N);
        vector<bool> v2(M);
        long int number_1 = 0;
        long int number_2 = 0;
        for (int i = 0; i < N; i++){
            v1[i] = rand() % 2;
            number_1 += (long int)v1[i] << i;
        }
        for (int i = 0; i < M; i++){
            v2[i] = rand() % 2;
            number_2 += (long int)v2[i] << i;
        }

        vector<bool> v_add_result = binaryOperations.addition(v1, v2);
        vector<bool> v_mul_result = binaryOperations.multiplication(v1, v2);
        vector<bool> v_sub_result, v_div_result;
        if(number_1 >= number_2){
            if(number_2 != 0){
                v_div_result = binaryOperations.division(v1, v2);
            }
            v_sub_result = binaryOperations.subtraction(v1, v2);
        }else{
            if(number_1 != 0){
                v_div_result = binaryOperations.division(v2, v1);
            }
            v_sub_result = binaryOperations.subtraction(v2, v1);
        }

        //Convert the binary vectors to integers using bitwise shift operations
        long int add_result = 0, sub_result = 0, mul_result = 0, div_result = 0;
        for (int i = 0; i < 2 * 32; i++) {
            add_result += (long int)v_add_result[i] << i;
            sub_result += (long int)v_sub_result[i] << i;
            mul_result += (long int)v_mul_result[i] << i;
            if(v_div_result.size()!=0) {
                div_result += (long int)v_div_result[i] << i;
            }
        }


        cout << "Test " << j + 1 << endl;
        cout << "v1: ";
        for (int i = N - 1; i >= 0; i--) {
            cout << v1[i];
        }
        cout << " (" << number_1 << ")" << " NB BITS = " << N << endl;
        cout << "v2: ";
        for (int i = M - 1; i >= 0; i--) {
            cout << v2[i];
        }
        cout << " (" << number_2 << ")" << " NB BITS = " << M << endl;
        cout << "v1 > v2 --> sub = v1 - v2 and div = v1 / v2" << endl;
        cout << "v2 > v1 --> sub = v2 - v1 and div = v2 / v1" << endl;
        cout << "result of division is an integer value" << endl;
        cout << "Addition test value:       " << add_result << " expected value: " << number_1 + number_2 << endl;
        cout << "Subtraction test value:    " << sub_result << " expected value: " << abs(number_1 - number_2)
             << endl;
        cout << "Multiplication test value: " << mul_result << " expected value: " << number_1 * number_2 << endl;
        if (number_1 >= number_2 && number_2 != 0) {
            cout << "Division test value:       " << div_result << " expected value: " << number_1 / number_2
                 << endl;
        } else if (number_1 <= number_2 && number_1 != 0) {
            cout << "Division test value:       " << div_result << " expected value: " << number_2 / number_1
                 << endl;
        }
        cout << "\n";
    }

    //test bench FPU
    FPU fpu;
    float_ieee_754 f1, f2, f_theory, f_practice;
    int cpt_number_test = 0;
    int cpt_add_valid = 0;
    int cpt_sub_valid = 0;
    int cpt_mul_valid = 0;
    int cpt_div_valid = 0;
    int low = -10000;
    int high = 10000;
    srand(time(NULL));

    for(int i = 0; i < 1000; i++){
        f1.value = low + static_cast<float>(rand()) * static_cast<float>(high - low) / RAND_MAX;
        f2.value = -1 + static_cast<float>(rand()) * static_cast<float>(2) / RAND_MAX;

        f_theory.value = f1.value + f2.value;
        f_practice = fpu.addition(f1, f2);
        if((f_theory.mantissa - f_practice.mantissa) == 0 || (f_theory.mantissa - f_practice.mantissa) == 1 || (f_theory.mantissa - f_practice.mantissa) == -1){
            cpt_add_valid++;
        }
        f_theory.value = f1.value - f2.value;
        f_practice = fpu.subtraction(f1, f2);
        if((f_theory.mantissa - f_practice.mantissa) == 0 || (f_theory.mantissa - f_practice.mantissa) == 1 || (f_theory.mantissa - f_practice.mantissa) == -1){
            cpt_sub_valid++;
        }else{
            cout << f_theory.mantissa << " " << f_practice.mantissa << endl;
        }
        f_theory.value = f1.value * f2.value;
        f_practice = fpu.multiplication(f1, f2);
        if((f_theory.mantissa - f_practice.mantissa) == 0 || (f_theory.mantissa - f_practice.mantissa) == 1 || (f_theory.mantissa - f_practice.mantissa) == -1){
            cpt_mul_valid++;
        }
        f_theory.value = f1.value / f2.value;
        f_practice = fpu.division(f1, f2);

        if((f_theory.mantissa - f_practice.mantissa) == 0 || (f_theory.mantissa - f_practice.mantissa) == 1 || (f_theory.mantissa - f_practice.mantissa) == -1 || (f_theory.mantissa - f_practice.mantissa) == -2 || (f_theory.mantissa - f_practice.mantissa) == 2){
            cpt_div_valid++;
        }       else{
        cout << f_theory.mantissa << " " << f_practice.mantissa << endl;
    }
        cpt_number_test++;
    }

    cout << "number test : " << (double)cpt_number_test << endl;
    cout << "add test : " << (double)cpt_add_valid/cpt_number_test << endl;
    cout << "sub test : " << (double)cpt_sub_valid/cpt_number_test << endl;
    cout << "mul test : " << (double)cpt_mul_valid/cpt_number_test << endl;
    cout << "div test : " << (double)cpt_div_valid/cpt_number_test << endl;

    return 0;

}
