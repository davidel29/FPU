# Opérations flotantes en C++
Cette partie présente les méthodes **addition**, **soustraction**, **multiplication** et **division** appartenant à la classe **FPU**. Le but de ces méthodes est d'effectuer des opérations à virgule flottante sur des nombres représentés au format IEEE 754 à l'aide du type **float_ieee_754**. Les méthodes renvoient ensuite le résultat sous la forme d'un **float_ieee_754** après des opérations sur les exposants, les signes et les mantisses.
## Addition
La première étape de la méthode consiste à aligner les mantisses des deux nombres en déplaçant le point décimal vers la droite ou la gauche si nécessaire, de manière à ce que les deux aient le même exposant. Cela est accompli par la fonction "align_mantissas", qui n'est pas montrée dans le code fourni.
La prochaine étape consiste à effectuer l'addition ou la soustraction des mantisses en fonction des signes des deux nombres. Si les deux ont le même signe, les mantisses sont ajoutées et le signe du résultat est défini sur le signe de l'un ou l'autre des entrées. Si les signes sont différents, les valeurs absolues des deux mantisses sont soustraites et le signe du résultat est défini sur le signe de la valeur absolue la plus grande.

Enfin, le résultat est normalisé en ajustant l'exposant et la mantisse de manière à ce que la mantisse soit dans la plage [1,0, 2,0) et que l'exposant soit ajusté en conséquence.
## Soustraction

## Multiplication

## Division

## Alignement de la mantisse

## Normalisation
