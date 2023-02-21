# FPU
Cloner le repository Github :
```shell
git clone https://github.com/davidel29/FPU.git
```
Aller dans le répertoire FPU :
```shell
cd FPU
```
## Modèle en C++
Aller dans le répertoire FPU_cpp :
```shell
cd FPU_cpp
```
Créer un répertoire build :
```shell
mkdir build
```
Aller dans le répertoire build :
```shell
cd build
```
Configurer le projet avec CMake :
```shell
cmake ..
```
Construire le projet avec le Makefile :
```shell
make
```
Exécuter le fichier FPU ;
```shell
./FPU_cpp
```
## Implémentation hardware en VHDL
Aller dans le répertoire FPU_VHDL :
```shell
cd FPU_VHDL
```
### Simulation avec GHDL
Aller dans le répertoire sim :
```shell
cd sim
```
Exécuter le fichier compile.x :
```shell
./compile.x
```
### Synthèse sur FPGA
Aller dans le répertoire syn :
```shell
cd syn
```
Synthétiser le code avec Vivado :
```shell
vivado -mode tcl -source script.tcl
```
Charger le bitstream avec l'outil de Digilent :
```shell
djtgcfg prog -d Nexys4DDR -i 0 -f SYNTH_OUTPUTS/top.bit
```
### Test IP FPU
Aller dans le répertoire sw :
```shell
cd sw
```
Créer un environnement local Ruby :
```shell
mkdir gem
cd gem
GEM_HOME=~/gem
gem install uart
cd ..
```
Lancer le script ruby :
```shell
ruby uart_send_test.rb 
```
