#include "Binary_operations.h"

Binary_operations::Binary_operations() {}

vector<bool> Binary_operations::addition(vector<bool> v1, vector<bool> v2) {
    vector<bool> sum(max(v1.size(), v2.size()), false);
    v1.resize(max(v1.size(), v2.size()));
    v2.resize(max(v1.size(), v2.size()));
    bool carry = false;
    for(int i = 0; i < max(v1.size(), v2.size()); i++){
        sum[i] = (v1[i] ^ v2[i]) ^ carry;
        carry = ((v1[i] & v2[i]) | (v1[i] & carry)) | (v2[i] & carry);
    }
    sum.push_back(carry);
    return sum;
}

vector<bool> Binary_operations::multiplication(vector<bool> v1, vector<bool> v2) {
    vector<bool> sum(v1.size() + v2.size(),false);
    vector<bool> product(v1.size() + v2.size(),false);
    for(int i = 0; i < v2.size(); i++){
        if (v2[i]){
            for (int j = 0; j < v1.size(); j++) {
                product[j + i] = v1[j];
            }
            sum = addition(product,sum);
            std::fill(product.begin(), product.end(), false);
        }
    }
    sum.resize(v1.size() + v2.size());
    return sum;
}

vector<bool> Binary_operations::subtraction(vector<bool> v1, vector<bool> v2) {
    vector<bool> different(max(v1.size(), v2.size()), false);
    v1.resize(max(v1.size(), v2.size()));
    v2.resize(max(v1.size(), v2.size()));
    bool carry = false;
    for(int i = 0; i < max(v1.size(), v2.size()); i++){
        different[i] = ((v1[i] ^ v2[i]) ^ carry) | v1[i] & v2[i] & carry;
        carry = v2[i] & carry | not(v1[i]) & (carry ^ v2[i]);
    }
    return different;
}

vector<bool> Binary_operations::division(vector<bool> v1, vector<bool> v2) {
    vector<bool> dividend(v1.size() + 1, false);
    vector<bool> old_dividend(v1.size() + 1, false);
    vector<bool> divisor = v2;
    divisor.resize(v1.size() + 1);
    vector<bool> quotient(v1.size(), false);
    for(int i = 0; i < v1.size(); i++) {
        //shift left
        for(int j = v1.size(); j > 0; j--){
            dividend[j] = dividend[j - 1];
            quotient[j] = quotient[j - 1];
        }
        dividend[0] = v1[v1.size() - i - 1];
        quotient[0] = false;
        old_dividend = dividend;
        dividend = subtraction(dividend,divisor);
        if(dividend[v1.size()]){
            dividend = old_dividend;
        }else{
            quotient[0] = true;
        }
    }
    return quotient;
}
