# Norme IEEE-754
La norme IEEE 754 définit deux formats de représentation des nombres à virgule flottante : simple précision (32 bits) et double précision (64 bits). Elle spécifie des règles pour la conversion des nombres en virgule flottante en nombres décimaux et inversement.  
Elle définit également les règles pour les opérations arithmétiques sur les nombres à virgule flottante, telles que l'addition, la soustraction, la multiplication et la division. Ces règles incluent des spécifications pour les cas particuliers tels que la division par zéro, les débordements et les valeurs indéfinies.
## Représentation simple précision
La simple précision est un format de représentation des nombres à virgule flottante défini dans la norme IEEE 754. Ce format utilise 32 bits pour représenter un nombre en virgule flottante, qui se compose de trois parties : le signe, l'exposant et la mantisse.   
- **Le signe** : le bit le plus significatif représente le signe du nombre, 0 pour un nombre positif et 1 pour un nombre négatif. 
- **L'exposant** : les huit bits suivants représentent l'exposant, qui détermine la position de la virgule dans la mantisse. 
- **La mantisse** : les derniers 23 bits représentent la mantisse, qui est la partie significative du nombre. 
  
Cette représentation est utilisée pour l'implémentation C++ et VHDL proposée dans ce projet.
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
### Implémentation VHDL
```VHDL
  constant mantissa_length : integer := 24;
  constant exponent_length : integer := 8;
  constant mantissa_high : integer := mantissa_length - 1;
  constant exponent_high : integer := exponent_length - 1;
  subtype t_mantissa is unsigned(mantissa_high downto 0);
  subtype t_exponent is unsigned(exponent_high downto 0);

  type float_ieee_754 is record
    sign     : std_logic;
    exponent : t_exponent;
    mantissa : t_mantissa;
  end record;
```
