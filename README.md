# FPU
Cloner le repository Github :
```shel
git clone https://github.com/davidel29/FPU.git
```
Aller dans le répertoire FPU :
```shel
cd FPU
```
## Modèle en C++
Aller dans le répertoire FPU_cpp :
```shel
cd FPU_cpp
```
Créer un répertoire build :
```shel
mkdir build
```
Aller dans le répertoire build :
```shel
cd build
```
Configurer le projet avec CMake :
```shel
cmake ..
```
Construire le projet avec le Makefile :
```shel
make
```
Exécuter le fichier FPU ;
```shel
./FPU_cpp
```
## Implémentation hardware en VHDL
Aller dans le répertoire FPU_VHDL :
```shel
cd FPU_VHDL
```
### Simulation avec GHDL
Aller dans le répertoire sim :
```shel
cd sim
```
Exécuter le fichier compile.x :
```shel
./compile.x
```
### Test sur FPGA
Aller dans le répertoire syn :
```shel
cd syn
```
Synthétiser le code avec Vivado :
```shel
vivado -mode tcl -source script.tcl
```
Charger le bitstream avec l'outil de Digilent :
```shel
djtgcfg prog -d Nexys4DDR -i 0 -f SYNTH_OUTPUTS/top.bit
```
