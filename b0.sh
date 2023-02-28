#!/bin/bash
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022
#Objectius de l'script: Eliminar totels les files amb valors nuls.
#Nom, tipus i nombre de línia o línies on es realitza la manipulació: Totes les files del dataset que continguin valors nuls.


echo -e "\033[38;2;0;255;255m******************************************************************\033[m"
echo -e "\033[38;2;0;255;255m********************* Executant Script: b0.sh ********************\n\033[m"

echo -e "\033[2;37m[INFO] Processant les dades...\033[m" 

# Eliminem csv antic si existeix
if [ -e customers_0.csv ]; 
	then
	  gio trash customers_0.csv
fi

# Eliminació de les files amb valors nuls.
sed '/^,/d; /,$/d; /, ,/d; /,,/d ' $1 > customers_0.csv


echo -e "\033[2;37m[INFO] Modificacions desades en fitxer customers_0.csv.\033[m"
echo -e "\033[2;37m[INFO] Accions:\033[m"
echo -e "\033[2;37m[INFO] - Eliminació files amb valors nuls.\033[m"

echo -e "\n"
echo -e "\033[36m********************* Execució Finalitzada ***********************\033[m"
echo -e "\033[36m******************************************************************\n\033[m"
