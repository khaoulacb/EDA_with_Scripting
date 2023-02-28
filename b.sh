#!/bin/bash
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022
#Objectius de l'script: Crear categories de rang d'edat per tal de poder agrupar els clients.
#Nom, tipus i nombre de línia o línies on es realitza la manipulació: Age_Range(string).

echo -e "\033[38;2;0;255;255m******************************************************************\033[m"
echo -e "\033[38;2;0;255;255m********************* Executant Script: b.sh *********************\n\033[m"

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
    echo "${fields[@]},Age_Range" | tr ' ' ','  
    # Canvia el valor de l'indicador per tal d'establir que ja s'ha imprés el header.
    header_encountered=1
  else
    # Establir el rang d'edat segons el valor d'edat a la columna Age.
    if [ "${fields[29]}" -lt 18 ]
    then
      age_range="<18"
    elif [ "${fields[29]}" -lt 30 ]
    then
      age_range="18-29"
    elif [ "${fields[29]}" -lt 40 ]
    then
      age_range="30-39"
    elif [ "${fields[29]}" -lt 50 ]
    then
      age_range="40-49"
    elif [ "${fields[29]}" -lt 60 ]
    then
      age_range="50-59"
    elif [ "${fields[29]}" -lt 70 ]
    then
      age_range="60-69"
    else
      age_range="70+"
    fi
    
    # Donar com a sortida la fila actual amb el valor del rang concatenat.
    for field in "${fields[@]}"; do
    	output_line+="${field},"
    done
    echo "${output_line}$age_range"
    output_line=""
  fi
done 
} < $1 > customers_2.csv

echo -e "\033[2;37m[INFO] Dades desades en fitxer customers_2.csv.\033[m"
echo -e "\033[2;37m[INFO] Accions:\033[m"
echo -e "\033[2;37m[INFO] - Creació columna Age_Range(string)\033[m"

echo -e "\n"
echo -e "\033[36m********************* Execució Finalitzada ***********************\033[m"
echo -e "\033[36m******************************************************************\n\033[m"


