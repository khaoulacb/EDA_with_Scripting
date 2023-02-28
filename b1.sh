#!/bin/bash
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022
#Objectius de l'script: Crear nova columna que classifica els clients per aquells que conviuen amb nens i els que no. La nova variable adopta valors de 0 (No) i 1 (Sí). El resultat és a partir de les columnes Kidhome i Teenhome.
#Nom, tipus i nombre de línia o línies on es realitza la manipulació: Has_Children(integer)


echo -e "\033[38;2;0;255;255m******************************************************************\033[m"
echo -e "\033[38;2;0;255;255m********************* Executant Script: b1.sh ********************\n\033[m"

echo -e "\033[2;37m[INFO] Processant les dades...\033[m" 

{
IFS=","

# Variable per indicar quan la línea actual és el header.
header_encountered=0

# Itera sobre cada línea del csv.
while read -r -a fields
do
  # Mira si el header ja ha sigut processat.
  if [ "$header_encountered" -eq 0 ]
  then
    echo "${fields[@]},Has_Children" | tr ' ' ','  
    # Canvia el valor de l'indicador per tal d'establir que ja s'ha imprés el header.
    header_encountered=1
  else
    # Suma de les columnes Kidhome i Teenhome.
    sum=$((fields[5]+fields[6]))
    
    if [ $sum -eq 0 ]
    then
    	has_children=0
    else
    	has_children=1
    fi
    
    # Donar com a sortida la fila actual amb el valor del rang concatenat.
    for field in "${fields[@]}"; do
    	output_line+="${field},"
    done
    echo "${output_line}$has_children"
    output_line=""
  fi
done 
} < $1 > customers_4.csv


echo -e "\033[2;37m[INFO] Modificacions desades en fitxer customers_4.csv.\033[m"
echo -e "\033[2;37m[INFO] Accions:\033[m"
echo -e "\033[2;37m[INFO] - Creació columna Has_Children(integer)\033[m"


# Eliminació dels csv del processat intermig:
# Verifiquem que el darrer fitxer existeix, i si és així, procedim a eliminar els intermitjos.
if test -f customers_4.csv; then

   rm -f customers_0.csv
   rm -f customers_1.csv
   rm -f customers_2.csv
   rm -f customers_3.csv		
fi
echo -e "\033[2;37m[INFO] Eliminant fitxers intermitjos...\033[m"
echo -e "\n"
echo -e "\033[36m********************* Execució Finalitzada ***********************\033[m"
echo -e "\033[36m******************************************************************\n\033[m"
