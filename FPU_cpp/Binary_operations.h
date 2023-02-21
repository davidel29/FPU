#ifndef FPU_BINARY_OPERATIONS_H
#define FPU_BINARY_OPERATIONS_H

#include <vector>

using namespace std;

class Binary_operations {

public:
    Binary_operations();
    vector<bool> addition(vector<bool> v1, vector<bool> v2);
    vector<bool> multiplication(vector<bool> v1, vector<bool> v2);
    vector<bool> subtraction(vector<bool> v1, vector<bool> v2);
    vector<bool> division(vector<bool> v1, vector<bool> v2);
};

#endif //FPU_BINARY_OPERATIONS_H