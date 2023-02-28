#! /usr/bin/awk -f
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022
#Objectius de l'script: Fer el càlcul d'anys que el client porta donat d'alta com a tal a partir de la columna Dt_Customer(date), obtenint així una columna nova Years_As_Customer(integer).
#Nom, tipus i nombre de línia o línies on es realitza la manipulació: Years_As_Customer(integer).



BEGIN { FS=OFS=","
	
   { print "\033[38;2;0;255;255m******************************************************************\033[m" }
   { print "\033[38;2;0;255;255m********************* Executant Script: b.awk ********************\n\033[m" }
	#Creació de fitxer csv on volcarem les modificacions.
	output_file = "customers_1.csv"
   { print "\033[2;37m[INFO] Processant les dades...\033[m" }

}

{
    sub("\r", "", $29) #Elimina el "carriage-return" de la darrera columna.
    if (NR == 1) {
	# Print del header amb el nom de les noves columnes afegides.
	print $0 ",Age,Years_As_Customer" > output_file
    } else {
	# Fem un "split" dels valors a la data, separats per guió.
	split($8, date, "-")
	# Variable any actual.
	current_year = strftime("%Y")
	# Càlcul de la nova variable years_as_customer i age (edat).
	years_as_customer = current_year - date[3]
	age = current_year - $2
	# Print del resultat al fitxer creat.
	print $0 "," age "," years_as_customer >> output_file
    }
}

END {
   close(output_file)
   { print "\033[2;37m[INFO] Dades desades en fitxer customers_1.csv.\033[m" }
   { print "\033[2;37m[INFO] Accions:\033[m" }
   { print "\033[2;37m[INFO] - Creació columna Age(integer)\033[m" }
   { print "\033[2;37m[INFO] - Creació columna Years_As_Customer(integer).\033[m" }   
   { print "\n" }
   { print "\033[36m********************* Execució Finalitzada ***********************\033[m" }
   { print "\033[36m******************************************************************\n\033[m" }	
}


