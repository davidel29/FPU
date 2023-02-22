# Opérations flotantes en C++
Cette partie présente les méthodes **addition**, **soustraction**, **multiplication** et **division** appartenant à la classe **FPU**. Le but de ces méthodes est d'effectuer des opérations à virgule flottante sur des nombres représentés au format IEEE 754 à l'aide du type **float_ieee_754**. Les méthodes renvoient ensuite le résultat sous la forme d'un **float_ieee_754** après des opérations sur les exposants, les signes et les mantisses.
## Addition
```C++
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
```
1) La première étape de la méthode consiste à aligner les mantisses des deux nombres en déplaçant le point décimal vers la droite ou la gauche si nécessaire, de manière à ce que les deux aient le même exposant. Cela est accompli par la fonction **align_mantissas**, qui n'est pas montrée dans le code fourni.    
2) La prochaine étape consiste à effectuer l'addition ou la soustraction des mantisses en fonction des signes des deux nombres. Si les deux ont le même signe, les mantisses sont ajoutées et le signe du résultat est défini sur le signe de l'un ou l'autre des entrées. Si les signes sont différents, les valeurs absolues des deux mantisses sont soustraites et le signe du résultat est défini sur le signe de la valeur absolue la plus grande.   
3) Enfin, le résultat est normalisé en ajustant l'exposant et la mantisse de manière à ce que la mantisse soit dans la plage de valeur correcte.
## Soustraction
```C++
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
```
1) La première étape de la méthode consiste à aligner les mantisses des deux nombres en déplaçant le point décimal vers la droite ou la gauche si nécessaire, de manière à ce que les deux aient le même exposant. Cela est accompli par la fonction **align_mantissas**, qui n'est pas montrée dans le code fourni.    
2) La prochaine étape consiste à effectuer l'addition ou la soustraction des mantisses en fonction des signes des deux nombres. Si les deux ont le même signe, les mantisses sont ajoutées et le signe du résultat est défini sur le signe de l'un ou l'autre des entrées. Si les signes sont différents, les valeurs absolues des deux mantisses sont soustraites et le signe du résultat est défini sur le signe de la valeur absolue la plus grande.   
3) Enfin, le résultat est normalisé en ajustant l'exposant et la mantisse de manière à ce que la mantisse soit dans la plage de valeur correcte.
## Multiplication
```C++
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
```
1) La première étape vectorise les mantisses des nombres d'entrée en stockant chaque bit des mantisses dans un élément séparé de deux vecteurs intermédiaires, **v_intermediate_mantissa_1** et **v_intermediate_mantissa_2**. La taille de ces vecteurs est **size_intermediate_mantissa**.
2) Ensuite, le prochaine étape consiste en une multiplication binaire des mantisses à l'aide de la méthode **multiplication** de l'objet **binary_operations**. Cela donne un vecteur intermédiaire, **v_intermediate_mantissa_out**, qui contient le produit des mantisses.
3) L'étape suivant est normalisation de la mantisse résultatne en ajustant l'exposant et la mantisse pour s'assurer que la mantisse est sous forme normalisée. Si le bit le plus significatif de **v_intermediate_mantissa_out** est défini, le code incrémente l'exposant et décale la mantisse vers la droite jusqu'à ce que le bit le plus significatif ne soit plus défini. Si le bit le plus significatif de **v_intermediate_mantissa_out** n'est pas défini, le code décale la mantisse vers la gauche jusqu'à ce que le bit le plus significatif soit défini.
4) Pour finir, le signe est définie comme la sortie du XOR des signes des nombres d'entrée.
## Division
```C++
float_ieee_754 FPU::division(float_ieee_754 f1, float_ieee_754 f2) {
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
```
## Alignement des mantisses
```C++
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
```
## Normalisation
```C++
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
```
