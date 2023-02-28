#!/bin/bash
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022

echo -e '\033[38;2;0;255;255m******************************************************************\033[m'
echo -e '\033[38;2;0;255;255m********************* Executant Script: a.sh *********************\n\033[m'


# Verifiquem si el fitxer de dades existeix, i en cas afirmatu l'eliminem.
if test -f customers.csv; then

	rm -f customers.csv
	rm -f customers_0.csv
	rm -f customers_1.csv
	rm -f customers_2.csv
	rm -f customers_3.csv
	rm -f customers_4.csv		
fi


# Variables de nom fitxer i url de descàrrega.
filename='customers.csv'
download_url='https://docs.google.com/uc?export=download&id=1BNmNEq355Q8PmyB3qeyJGJZMqAhag23H'
source_url="https://www.kaggle.com/datasets/imakash3011/customer-personality-analysis"
source_name="Kaggle"

# Procès de descàrrega del fitxer de dades.
if test ! -e customers.csv; then
	echo -e '\033[2;37m[INFO] Descarrengant el fitxer de dades...\033[m'
	wget -q --no-check-certificate $download_url -O $filename
	echo -e '\033[2;37m[INFO] Descàrrega completada!\033[m'
	
fi

# Càlcul del nombre del tamany, files i columnes del dataset.
file_size=$(du -k $filename | awk '{print $1}')
rows=$(awk 'END {print NR}' $filename)
columns=$(awk -F, '{print NF}' $filename | sort -nu | tail -n 1)

echo -e '\n'
echo -e '+---------- INFORMACIÓ DEL DATASET ----------+\n'

# Verificar si es dona un paràmetre d'entrada.
# Cas nagatiu: es mostra URL de descàrrega, i nombre de columnes i registres.
# Cas positiu: es mostrarà la informació anterior, juntament amb el format del fitxer i el type de les dades. 
if [ $# -eq 0 ]; then
	
	echo -e "- Nom de la font: $source_name"
	echo -e "- URL de la font: $source_url"
	echo -e "- URL de descàrrega: $download_url"
	echo -e "- Total columnes: $columns"
	echo -e "- Total registres: $rows"
else 
	echo -e "- Nom de la font: $source_name"
	echo -e "- URL de la font: $source_url"
	echo -e "- URL de descàrrega: $download_url"
	echo -e "- Format del fitxer: ${filename##*.}"
	echo -e "- Mida de l'arxiu: $file_size kb"
	echo -e "- Total columnes: $columns"
	echo -e "- Total registres: $rows"	
	echo -e "\n"
	echo -e "....... Tipus de dades ......."

	# Recorrem el document csv.
	awk -F, 'NR==1 {
	  # Guardem el nom de les columnes
	  for (i=1; i<=NF; i++) {
	    column_names[i] = $i
	  }
	} NR>1 {
	  # Agafem el primer registre que no contingui valors nuls 
	  for (i=1;i<=NF;i++) {
	     if ($i=="" || $i==" ") {
	     	next
	     } else {
	        # Classifiquem cada valor pel type segons el patró amb el que coincideixi
	        for (i=1; i<=NF; i++) {
	          if ($i ~ /^[0-9]+(\s)*$/) {
	              data_types[i] = "integer"
	           } else if ($i ~ /^[0-9]+\.[0-9]+(\s)*$/) {
	              data_types[i] = "float"
	           } else if ($i ~ /^[0-9]{2}(-|\/)[0-9]{2}(-|\/)[0-9]{4}(\s)*$/) {
	              data_types[i] = "date"
	           } else if ($i ~ /^((T|t)rue|(F|f)alse)(\s)*$/) {
	              data_types[i] = "boolean"	              
	           } else {
	              data_types[i] = "string"
	           }
	        }; exit
	     }
	  }
	} 
	END {
	  # Imprimim el nombre de la columna i el data type que correspon
	  printf "%-24s %-20s\n", "Columna", "Data type"
	  print "+-------------------+-----------------+"
	  for (i=1; i<NF; i++) {
	    printf "%-24s %-20s\n", column_names[i], data_types[i]
	  }
	  # Línea que corregeix un error que es produeix a AWK en els printf
	  printf "%s\t\t\t %-20s\n", column_names[NF], data_types[NF]
	}' $filename
fi

echo -e '\n'
echo -e '\033[36m********************* Execució Finalitzada ***********************\033[m'
echo -e '\033[36m******************************************************************\n\033[m'

