#! /usr/bin/awk -f
#Nom i cognoms de l'alumne: Khaoula Chentouf ElBahja
#Usuari de la UOC de l'alumne: kchentouf
#Data: 30/12/2022
#Objectius de l'script: Crear columna amb total despesa per client + Crear columna total campanyes acceptades per client.
#Nom, tipus i nombre de línia o línies on es realitza la manipulació: Total_Cmp_Accepted(integer), Total_Spent(integer).



BEGIN { FS=OFS=","
	
   { print "\033[38;2;0;255;255m******************************************************************\033[m" }
   { print "\033[38;2;0;255;255m********************* Executant Script: b1.awk *******************\n\033[m" }
	# Creació de fitxer csv on volcarem les modificacions.
	output_file = "customers_3.csv"
   { print "\033[2;37m[INFO] Processant les dades...\033[m" }

}

{  
    # Imprimeix la capçalera o header al nou fitxer.
    sub("\r", "", $32) # Elimina el "carriage-return" de la darrera columna.
    if (NR == 1) {
	# Print del header amb el nom de les noves columnes afegides.
	print $0 ",Total_Spent,Total_Cmp_Accepted" > output_file
    } else {
	# Print de les columnes, juntament amb les noves.
	print $0 "," ($10+$11+$12+$13+$14+$15) "," ($21+$22+$23+$24+$25+$29) >> output_file
    }
}

END {
   close(output_file)
   { print "\033[2;37m[INFO] Dades desades en fitxer customers_3.csv.\033[m" }
   { print "\033[2;37m[INFO] Accions:\033[m" }
   { print "\033[2;37m[INFO] - Creació columna Total_Spent(integer)\033[m" }
   { print "\033[2;37m[INFO] - Creació columna Total_Cmp_Accepted(integer).\033[m" }   
   { print "\n" }
   { print "\033[36m********************* Execució Finalitzada ***********************\033[m" }
   { print "\033[36m******************************************************************\n\033[m" }	
}


