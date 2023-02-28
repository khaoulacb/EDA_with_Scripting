#!/bin/bash
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022
#Objectiu: Crear un informe de l'anàlisi descriptiu dels clients continguts en el dataset.
#Nom i tipus dels camps d'entrada: Com a entrada, tenim el dataset customers_4.csv (que es el darrer dataset generat a partir dels processos previs.
#Operacions i núm. línia o línies on es realitzen:
#Nom i tipus de els nou camps generats:


echo -e '\033[38;2;0;255;255m******************************************************************\033[m'
echo -e '\033[38;2;0;255;255m********************* Executant Script: c.sh *********************\n\033[m'

# Comprovar si el fitxer report.txt existeix, i en cas que sí, eliminar-lo.
if [ -f "report.txt" ]; then
  rm "report.txt"
fi


{
   echo -e "**********************  INFORME D'ANÀLISIS DE DADES DE CLIENTS  **********************\n"
   echo -e "Informe d'anàlisis descriptiu de les dades obtingudes sobre els clients registrats i la seva acceptació de les diferents campanyes promocionals.\n"
} > report.txt


  ############################################
 # APARTAT 1: ANÀLISIS GENERAL DE VARIABLES #
############################################

echo -e '\033[2;37m[INFO] Escriptura Apartat 1: Anàlisis general de variables.\033[m'

{ 
   echo -e "\n\t\t\t********************************************" 
   echo -e "\t\t\t* APARTAT 1: ANÀLISIS GENERAL DE VARIABLES *" 
   echo -e "\t\t\t********************************************\n\n"
   
} >>report.txt


#-----------------------------------------------------
# 1.1 -  TAULA 1- Descripció global dades numèriques +
#-----------------------------------------------------

# Comprovació si la línia d'execució inclou el nom d'un fitxer d'entrada.

if [ -z "$1" ]; then
  echo -e "\033[38;2;255;0;0m[ERROR] Sisplau, proporciona el nom del fitxer d'entrada com a paràmetre.\033[m"
  exit 1
fi

filename=$1

# Comprovació si el fitxer de dades existeix.
if [ ! -f "$filename" ]; then
  echo -e "\033[38;2;255;0;0m[ERROR] Fitxer no existeix: $filename\033[m"
  exit 1
fi


# Assignem a una variable la línia del header del document csv.
column_names=$(head -n 1 "$filename")
descriptor=("Count" "Mean" "Std Dev" "Min" "Max")

# Fem un split de les columnes del fitxer en un array
IFS=',' read -r -a columns <<< "$column_names"

# Creació d'un array amb el nom de columnes a descriure.
columns_to_analyze=(Age Years_As_Customer Total_Spent Total_Cmp_Accepted Recency)

# Creació de la taula.
{
   echo -e "\n DESCRIPCIÓ GLOBAL DADES NUMÈRIQUES"
   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf -- "------------+"
   done
   printf "\n"

   printf "| %-20s " "Column"
   
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf "| %-10s " "${descriptor[i-1]}"
   done
   printf "|\n"

   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf -- "------------+"
   done
   printf "\n"
}>> report.txt

# Iteració sobre cada columna
for column in "${columns_to_analyze[@]}"; do
  # Comprovació si el nom de la columna existeix en el llistat de columnes del csv
  if [[ " ${columns[*]} " != *" $column "* ]]; then
    echo -e "\033[38;2;255;0;0m[ERROR] Column not found: $column\033[m"
    continue
  fi

  # Obtenció de l'index de cada columna.
  index=$(head -n1 $filename | tr "," "\n" | grep -nx $column |  cut -d":" -f1)

  # Obtenció del nombre de files en aquesta columna.
  count=$(cut -d',' -f"$index" "$filename" | wc -l)
  
  # Càlcul de la mitjana dels valors de la columna.
  mean=$(cut -d',' -f"$index" "$filename" | awk '{ sum += $1 } END { if (NR > 0) printf "%.3f\n", sum / NR }')
  
  # Càlcul de la desviació estàndard en la columna.
  stddev=$(cut -d',' -f"$index" "$filename" | awk '{sum+=$1; sumsq+=$1*$1} END {printf "%.3f\n", sqrt(sumsq/NR - (sum/NR)**2)}')
  
  # Càlcul del valor mínim.
  min=$(cut -d',' -f"$index" "$filename" | sort -n | tail -n +2 | head -n 1)
  # Càlcul del valor màxim.
  max=$(cut -d',' -f"$index" "$filename" | sort -n | tail -n 1)
  
  # Impressió dels resultats de la columna actual a la taula.
  {
     printf "| %-20s | %-10s | %-10s | %-10s | %-10s | %-10s |\n" "$column" "$count" "$mean" "$stddev" "$min" "$max"
  } >> report.txt
done

{
   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
   printf -- "------------+"
   done
   printf "\n"
   echo -e "Taula 1: descripció genèrica de les dades numèriques més rellevants."
   echo -e "\n"
} >> report.txt


#-------------------------------------------------------
# 1.2 -  TAULA 2- Descripció global dades categòriques +
#-------------------------------------------------------


# Creació d'un array amb el nom de columnes a descriure.
columns_to_analyze=(Education Marital_Status)
descriptor=("Count" "Unique" "Top" "Freq")


# Fem un split de les columnes del fitxer en un array
IFS=',' read -r -a columns <<< "$column_names"


# Print de l'output de la taula amb les línies.
{
   echo -e "\n DESCRIPCIÓ GLOBAL DADES CATEGÓRIQUES"
   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf -- "------------+"
   done
   printf "\n"

   printf "| %-20s " "Column"
   
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf "| %-10s " "${descriptor[i-1]}"
   done
   printf "|\n"

   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf -- "------------+"
   done
   printf "\n"
}>> report.txt

# Iteració sobre cada columna a analitzar i comprovació de la seva existència al csv.
for column in "${columns_to_analyze[@]}"; do
  if [[ " ${columns[*]} " != *" $column "* ]]; then
    echo -e "\033[38;2;255;0;0m[ERROR] Column not found: $column\033[m"
    continue
  fi

  # Obtenció de l'índex de cada columna.
  index=$(head -n1 $filename | tr "," "\n" | grep -nx $column |  cut -d":" -f1)

  # Càlcul del nombre de files en cada columna.
  count=$(cut -d',' -f"$index" "$filename" | wc -l)
  
  # Obtenció del nombre de valors únics que té la variable.
  unique=$(cut -d, -f"$index" "$filename" | sed '1d' | awk '!seen[$0]++' | wc -l)

  # Obtenció del valor "top" o més repetit de la columna.
  top=$(cut -d, -f"$index" "$filename" | sort | uniq -c | sort -nr | head -n1 | awk '{print $2}')
  
  # Obtenció del valor freq més elevada (nombre de cops el valor "top" apareix).
  freq=$(cut -d, -f"$index" "$filename" | sort | uniq -c | sort -nr | head -n1 | awk '{print $1}')
  
  # Imprimex els resultats de cada columna a la taula.
  {
     printf "| %-20s | %-10s | %-10s | %-10s | %-10s |\n" "$column" "$count" "$unique" "$top" "$freq"
  } >> report.txt
done

{
   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
   printf -- "------------+"
   done
   printf "\n"
   echo -e "Taula 2: descripció genèrica de les dades categòriques més rellevants."
   echo -e "\n"
} >> report.txt


#---------------------------------------------------
# 1.3 -  TAULA 3- Descripció global dades binàries +
#---------------------------------------------------


# Creació d'un array amb el nom de columnes a descriure.
columns_to_analyze=(Has_Children Complain Response)
descriptor=("Yes" "No")

# Fem un split de les columnes del fitxer en un array
IFS=',' read -r -a columns <<< "$column_names"


# Print de l'output de la taula amb les línies.
{
   echo -e "\n DESCRIPCIÓ GLOBAL DADES BINÀRIES"
   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf -- "------------+"
   done
   printf "\n"

   printf "| %-20s " "Column"
   
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf "| %-10s " "${descriptor[i-1]}"
   done
   printf "|\n"

   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
     printf -- "------------+"
   done
   printf "\n"
}>> report.txt

# Iteració sobre cada columna a analitzar i comprovació de la seva existència al csv.
for column in "${columns_to_analyze[@]}"; do
  if [[ " ${columns[*]} " != *" $column "* ]]; then
    echo -e "\033[38;2;255;0;0m[ERROR] Column not found: $column\033[m"
    continue
  fi

   # Obtenció de l'índex cada columna.
   index=$(head -n1 $filename | tr "," "\n" | grep -nx $column |  cut -d":" -f1)
   
   # Extracció de la columna del csv i es fa el comptatge del nombre de 0s i 1s.
   zero_count=$(cut -d, -f"$index" "$filename" | awk '$0 == 0' | wc -l)
   one_count=$(cut -d, -f"$index" "$filename" | awk '$0 == 1' | wc -l)

   # Càlcul del nombre total de valors
   total_count=$((zero_count + one_count))

   # Càlcul del percentatge de 1s i 0s.
   zero_percent=$(echo "scale=2; 100 * $zero_count / $total_count" | bc)
   one_percent=$(echo "scale=2; 100 * $one_count / $total_count" | bc)
  
  # Imprimex els resultats de la cada columna a la taula.
  {
     printf "| %-20s | %-10s | %-10s |\n" "$column" "$one_percent%" "$zero_percent%"
  } >> report.txt
done

{
   printf "+"
   printf -- "----------------------+"
   for ((i=1;i<=${#descriptor[@]};i++)); do
   printf -- "------------+"
   done
   printf "\n"
   echo -e "Taula 3: descripció genèrica de les dades de tipus binari.\n"
   echo -e "\n"
} >> report.txt



  ##################################################
 # APARTAT 2: ANÀLISIS DE CLIENTS PER RANG D'EDAT #
##################################################

echo -e '\033[2;37m[INFO] Escriptura Apartat 2: Anàlisi de clients per rang edat.\033[m'

{ 
   echo -e "\t\t\t**************************************************" 
   echo -e "\t\t\t* APARTAT 2: ANÀLISIS DE CLIENTS PER RANG D'EDAT *" 
   echo -e "\t\t\t**************************************************\n\n\n"
   
} >>report.txt


#-----------------------------------------------------------
# 2.1 -  Gràfic 1- Percentatge de clients per rangs d'edat +
#-----------------------------------------------------------


column="Age_Range"
column_index=$(head -n1 $filename | tr "," "\n" | grep -nx $column |  cut -d":" -f1)

# Extracció del la columna del csv i càlcul de nombre de cops cada categoria apareix.
counts=$(cut -d, -f$column_index $filename | sed '1d' | sort | uniq -c)

# Càlcul del nombre total de files en el document.
total_count=$(wc -l < $filename)

# Càlcul del percentatge d'aparició de cada categoria.
percentages=$(echo "$counts" | awk '{print 100*$1/total}' total=$total_count)

# Ordenació dels resultats segons el count (ordre descendent).
sorted_data=$(paste <(echo "$counts") <(echo "$percentages") | sort -k1,1nr)

# Extracció de les categories, counts i percentatges ordets a partir del sort.
sorted_categories=$(echo "$sorted_data" | awk '{print $2}')
sorted_counts=$(echo "$sorted_data" | awk '{print $1}')
sorted_percentage=$(echo "$sorted_data" | awk '{print $3}')

# Troba el valor màxim per escalar el gràfic.
max_count=$(echo "$sorted_counts" | head -n1)

# El caràcter que formarà la barra de la visualiztació.
bar_char=$'\xe2\x96\x87'


char_per_unit=$((max_count / 30 + 1))

# Iteració sobre les dades ordenades (sorted) i imprimeix les barres del gràfic
{
   echo -e "PERCENTATGES DE CLIENTS PER RANGS D'EDAT\n"
   while read -r category count percentage; do
   
     num_bars=$((count / char_per_unit))
     percentage_num=$(echo "scale=2; $percentage / 1" | bc)
     
     printf "%-10s | %4s%% " "$category" "$percentage_num"
     for i in $(seq 1 $num_bars); do
       printf "%s" "$bar_char"
     done
     printf "\n"
   done <<< "$(paste <(echo "$sorted_categories") <(echo "$sorted_counts") <(echo "$sorted_percentage"))" | column -t
   echo -e "\nGràfic 1: Percentatge dels diferents rangs d'edat entre els clients registrats.\n\n"
}>>report.txt


#-----------------------------------------------------
# 2.2 -  Taula 4- Càlcul de mitjanes per rang d'edat +
#-----------------------------------------------------


# Comença la impressió dels límits de la taula.
{
   echo -e "\n CÀLCUL DE MITJANES PER RANG D'EDAT"
   printf "+"
   printf -- "-----------------+"
   printf -- "-----------------+"
   printf -- "-------------------+"
   printf -- "-----------------+"
   printf "\n"

   printf "| %-15s " "Age_Range"
   printf "| %-15s " "Avg Total_Spent"
   printf "| %-17s " "Avg Cmp_Accepted"
   printf "| %-15s |\n" "Avg Recency"
   
   printf "+"
   printf -- "-----------------+"
   printf -- "-----------------+"
   printf -- "-------------------+"
   printf -- "-----------------+"
   printf "\n"
}>> report.txt

# Càlcul de les mitjanes agrupades i la seva impressió al report.
awk -F, 'NR > 1 {a[$32]+=$33; b[$32]+=$34; c[$32]+=$9; d[$32]++} END {for (i in a) printf "| %-15s | %-15.3f | %-17.3f | %-15.3f |\n", i, a[i]/d[i], b[i]/d[i], c[i]/d[i]}' customers_4.csv | sort >> report.txt

{
   printf "+"
   printf -- "-----------------+"
   printf -- "-----------------+"
   printf -- "-------------------+"
   printf -- "-----------------+"
   printf "\n"
   echo -e "Taula 4: Mitjana de les variables numèriques més rellevants, agrupades per rang d'edat.\n\n"
   echo -e "\n"
} >> report.txt


  #################################################
 # APARTAT 3: ANÀLISIS DE LES DARRERES CAMPANYES #
#################################################

echo -e '\033[2;37m[INFO] Generant Apartat 3: Anàlisis de les darreres campanyes.\033[m'

{ 
   echo -e "\t\t\t*************************************************" 
   echo -e "\t\t\t* APARTAT 3: ANÀLISIS DE LES DARRERES CAMPANYES *" 
   echo -e "\t\t\t*************************************************\n\n\n"
   
} >>report.txt


file_name=$1
# Guardem la primera línea del fitxer (header) en una variable.
column_names=$(head -n 1 $file_name)

# Definim un array amb les columnes a analitzar.
columns_to_process=("AcceptedCmp1" "AcceptedCmp2" "AcceptedCmp3" "AcceptedCmp4" "AcceptedCmp5")

declare -a values
declare -a labels


for column_name in "${columns_to_process[@]}"; do

  index=$(head -n1 $filename | tr "," "\n" | grep -nx $column_name |  cut -d":" -f1)
  count=$(cut -d, -f"$index" "$filename" | awk '$0 == 1' | wc -l)

  values+=("$count")
  labels+=("$column_name")
done

mapfile -t values < <(printf '%s\n' "${values[@]}")
mapfile -t labels < <(printf '%s\n' "${labels[@]}")

# Ordenació de les dades en ordre descendent.
sorted_data=$(paste <(printf '%s\n' "${labels[@]}") <(printf '%s\n' "${values[@]}") | sort -k2,2nr)

# Extracció de les dades ordenades.
sorted_labels=$(echo "$sorted_data" | cut -f1)
sorted_values=$(echo "$sorted_data" | cut -f2)

# Trobem el valor màxim.
max_value=$(echo "$sorted_values" | head -n1)

# Definim el caràcter que formarà la barra de visualizació.
bar_char=$'\xe2\x96\x87'

# Definim el nombre de caràcter que representaràn cada unitat en les dades.
char_per_unit=$((max_value / 50 + 1))

{
   echo -e "GRÀFIC DE RESPOSTES A LES CAMPANYES\n"
   # Iteració sobre les dades ordenades i impressió del gràfic de barres.
   while read -r label value; do
     # Càlcul del nombre de caràcters a imprimir.
     num_bars=$((value / char_per_unit))

     # Impressió de la barra.
     printf "%-10s| %-4s " "$label" "$value"
     for i in $(seq 1 $num_bars); do
       printf "%s" "$bar_char"
     done
     printf "\n"
     printf "\n"
   done <<< "$(paste <(echo "$sorted_labels") <(echo "$sorted_values"))" | column -t
   echo -e "\nGràfic 2: Comparació de les diferents campanyes publicitàries pel total de clients que hi han donat resposta.\n\n"
} >>report.txt


{
   echo -e "**************************************************************************************\n"
} >>report.txt

echo -e '\033[2;37m[INFO] Resultats guardats en el fitxer report.txt.\033[m'

echo -e '\n'
echo -e '\033[36m********************* Execució Finalitzada ***********************\033[m'
echo -e '\033[36m******************************************************************\n\033[m'
