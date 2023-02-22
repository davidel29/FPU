# Norme IEEE-754
La norme IEEE 754 définit deux formats de représentation des nombres à virgule flottante : simple précision (32 bits) et double précision (64 bits). Elle spécifie également des règles pour la conversion des nombres en virgule flottante en nombres décimaux et inversement.
Elle définit également les règles pour les opérations arithmétiques sur les nombres à virgule flottante, telles que l'addition, la soustraction, la multiplication et la division. Ces règles incluent des spécifications pour les cas particuliers tels que la division par zéro, les débordements et les valeurs indéfinies.
## Représentation simple précision
La simple précision est un format de représentation des nombres à virgule flottante défini dans la norme IEEE 754. Ce format utilise 32 bits pour représenter un nombre en virgule flottante, qui se compose de trois parties : le signe, l'exposant et la mantisse.
Le bit le plus significatif représente le signe du nombre : 0 pour un nombre positif et 1 pour un nombre négatif. Les huit bits suivants représentent l'exposant, qui détermine la position de la virgule dans la mantisse. Le reste des bits (23 bits) représente la mantisse, qui est la partie significative du nombre. Cette représentation est utilisée pour l'implémentation C++ et VHDL proposée dans ce projet.
### Implémentation C++
```C++
typedef union {
    float value;
    struct
    {
        unsigned int mantissa : 23;
        unsigned int exponent : 8;
        unsigned int sign : 1;
    };
}float_ieee_754;
```
Ce code déclare un type union nommé float_ieee_754 qui contient une valeur de type float et une structure contenant trois champs de bits représentant le signe, l'exposant et la mantisse du format de nombre à virgule flottante IEEE 754.
Le champ de bits unsigned int mantissa a une largeur de 23 bits et représente la partie fractionnaire de la valeur en virgule flottante. Le champ de bits unsigned int exponent a une largeur de 8 bits et représente l'exposant de la valeur en virgule flottante. Le champ de bits unsigned int sign a une largeur de 1 bit et représente le signe de la valeur en virgule flottante.
L'utilisation d'un type union permet à la même adresse mémoire d'être interprétée soit comme un float, soit comme une structure contenant les trois champs de bits. Cela peut être utile pour effectuer des manipulations de bas niveau sur les bits qui représentent une valeur en virgule flottante. Par exemple, les champs de bits peuvent être utilisés pour extraire et modifier séparément le signe, l'exposant et la mantisse d'une valeur en virgule flottante.
### Implémentation VHDL
```VHDL
  type float_record is record
    sign     : std_logic;
    exponent : t_exponent;
    mantissa : t_mantissa;
  end record;
```
