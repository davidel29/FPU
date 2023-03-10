# IP FPU
IP_FPU désigne un bloc fonctionnel spécialisé pour l'exécution de calculs en virgule flottante, souvent présent dans les processeurs modernes.
L'implémentation d'un IP_FPU pour un système on chip est généralement différente de celle pour un processeur, car le SoC intègre plusieurs IP (processeur, mémoire, périphériques d'E/S, etc.) sur une même puce. Dans ce contexte, le bloc FPU peut être conçu comme un module distinct et interconnecté aux autres modules à l'aide d'un bus. Ici, on utilise un bus qui permet le contrôle de l'IP FPU qui est esclave. Le bus possède un seul maître qui est l'UART.
## Schéma de l'IP FPU
<img src="Images/ip_fpu.png">

## Schéma du système complet
<img src="Images/soc.png">

Dans le cas spécifique de l'IP FPU, le FPGA Nexys 4 DDR peut être programmé pour inclure l'IP FPU, qui peut être utilisé pour effectuer des calculs de virgule flottante dans le système on-chip.
