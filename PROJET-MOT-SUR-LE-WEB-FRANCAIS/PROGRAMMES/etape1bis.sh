#!/bin/bash
# 1. Lecture des param鑤res dans le fichier PARAMETRES
read DOSSIERURLS;
read fichier_tableau;
echo "Le dossier d'URLs : $DOSSIERURLS " ;
echo "Le fichier contenant le tableau : $fichier_tableau" ;
# 2. Affichage des tableaux
cpttableau=1;
echo "<html><head></head><body>" > $fichier_tableau ;
#====== pour chacun des fichiers d'URL ========
for fichier in `ls $DOSSIERURLS`
{ # debut du premier for
    #-------------------------------------------------
    # traitement d'un fichier d'URL
    compteur=1; # initialisation d'un compteur pour compter les URLs
	echo "<p align=\"center\"><hr color=\"blue\" width=\"80%\"/> </p>" >> $fichier_tableau ;
    echo "<table align=\"center\" border=\"1\">" >> $fichier_tableau ;
    echo "<tr><td colspan=\"8\" align=\"center\">tableau n<sup>o</sup> $cpttableau</td></tr>" >> $fichier_tableau ;
    echo "<tr><td align=\"center\"><b>N&deg;</b></td><td align=\"center\"><b>Lien</b></td><td align=\"center\"><b>CODE CURL</b><td align=\"center\"><b>statut CURL</b></td><td align=\"center\"><b>Page Aspir&eacute;e</b></td><td align=\"center\"><b>Encodage Initial</b></td><td align=\"center\"><b>DUMP initial</b></td><td align=\"center\"><b>DUMP UTF-8</b></td></tr>" >> $fichier_tableau ;
	#-------------------------------------------------
	# traitement de chacun des URLs
    for line in `cat $DOSSIERURLS/$fichier`
	#-------------------------------------------------
	# pour chacune des lignes du fichier d'URL trait<sup>o</sup> (une URL)...
    {
		# ==> ASPIRATION DE LA PAGE
		echo "TELECHARGEMENT de $line vers ../PAGES-ASPIREES/$cpttableau-$compteur.html" ;
		#curl $line -o ./PAGES-ASPIREES/"$cpttableau-$compteur".html ;
		echo "CODE RETOUR CURL : $?" ;
		# RECUPERATION DU HEADER HTTP
		status1=$(curl -sI $line | head -n 1);
		# RECUPERATION DU CODE RETOUR HTTP ET DE LA PAGE
		status2=$(curl --silent --output ../PAGES-ASPIREES/"$cpttableau-$compteur".html --write-out "%{http_code}" $line);
		echo "STATUT CURL : $status2" ;
		# ==> DETECTION DE L'ENCODAGE DE LA PAGE en ligne
		echo "DETECTION encodage de $line ";
        encodage=$(curl -sI $line | egrep -i "charset=" | cut -f2 -d= | tr -d "\n" | tr -d "\r" | tr "[:upper:]" "[:lower:]");
		echo "ENCODAGE $line : <$encodage>" ;
		if [[ $encodage == "utf-8" ]]
			then
				echo "DUMP de $line via lynx" ;
                lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ./DUMP-TEXT/$cpttableau-$compteur.txt ;
				echo "ECRITURE RESULTAT dans le tableau" ;
				echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">lien n<sup>o</sup>$compteur</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">-</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n<sup>o</sup> $cpttableau-$compteur</a></td></tr>" >> $fichier_tableau ;
			else
				# ICI D'AUTRES TRAITEMENTS A INSERER....
				# ... il faut transcoder le contenu de la page en UTF8
				echo "ECRITURE RESULTAT dans le tableau" ;
				echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">lien n<sup>o</sup>$compteur</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">-</td><td align=\"center\">-</td></tr>" >> $fichier_tableau ;
			fi
        # il faut ajouter 1 au compteur de lignes
        let "compteur=compteur+1";  # let "compteur+=1";
    }
	#----------------------------------------------------
    echo "</table>" >> $fichier_tableau ;
    let "cpttableau=cpttableau+1";
}
echo "</body></html>" >> $fichier_tableau ;
#=============================================
