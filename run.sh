#!/bin/bash
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022


# Otorgació de permisos als scripts executats en el present run.sh.

chmod +x a.sh b0.sh b.awk b.sh b1.awk b1.sh c.sh > /dev/null 2>&1

# Execució de l'Script a.sh
./a.sh [-v] &

wait

# Execució de l'Script b0.sh
./b0.sh customers.csv &

wait

# Execució de l'Script b.awk
gawk -f b.awk customers_0.csv &

wait

# Execució de l'Script b.sh
./b.sh customers_1.csv &

wait

# Execució de l'Script b1.awk
gawk -f b1.awk customers_2.csv &

wait

# Execució de l'Script b1.sh
./b1.sh customers_3.csv &

wait

# Execució de l'Script c.sh
./c.sh customers_4.csv 
