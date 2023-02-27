# Opétations binaires
## Addition
```C++
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
```
1) La fonction **addition** prend deux vecteurs booléens en entrée et retourne un nouveau vecteur booléen représentant la somme des deux vecteurs d'entrée. Elle commence par créer un vecteur de la taille maximale des deux vecteurs d'entrée. 
2) Ensuite, elle redimensionne les deux vecteurs d'entrée pour qu'ils aient la même taille que le vecteur de sortie en ajoutant des bits à 0 à la fin. Elle initialise une variable booléenne **carry** à false pour représenter la retenue lors de l'addition. 
3) Ensuite, elle parcourt les deux vecteurs d'entrée simultanément et calcule la somme bit à bit en prenant en compte la retenue. 
4) Enfin, elle ajoute la retenue finale au vecteur de sortie et le retourne.
## Multiplication
```C++
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
```
1) La fonction multiplication prend en entrée deux vecteurs de booléens, qui représentent des nombres binaires en tant que tableaux de bits, et retourne le produit de ces deux nombres également représenté sous forme de vecteur de booléens.
2) Le vecteur sum est utilisé pour stocker le résultat de la multiplication, et est initialisé avec une taille égale à la somme des tailles de v1 et v2. Le vecteur product est utilisé pour stocker les produits partiels de v1 en fonction de chaque bit de v2. 
3) Ensuite, la fonction parcourt les bits de v2 et, pour chaque bit à 1, elle multiplie v1 par ce bit en décalant les bits de v1 de i positions vers la gauche et stocke le résultat dans le vecteur product. 
4) Elle ajoute ensuite le produit partiel stocké dans product à la somme partielle stockée dans sum en appelant la fonction addition définie précédemment. 
5) De plus, elle réinitialise le vecteur product à des valeurs fausses avant de passer au bit suivant de v2. 
6) Enfin, la fonction redimensionne le vecteur sum pour avoir une taille égale à la taille de la multiplication de v1 par v2.
## Soustraction
```C++
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
```
1) Tout d'abord, la fonction crée un vecteur different de la même taille que le plus grand des deux vecteurs en entrée.
2) Ensuite, elle redimensionne **v1** et **v2** pour qu'ils aient la même taille que different. Cela permet de s'assurer que les deux vecteurs ont la même taille pour que la soustraction puisse être effectuée bit à bit.
3) De plus, pour chaque bit des vecteurs v1 et v2, la fonction effectue une soustraction bit à bit.
4) Enfin, la fonction met à jour carry pour la soustraction suivante.
## Division
```C++
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
```
