#!/bin/bash
# 1. Lecture des param<sup>o</sup>tres dans le fichier PARAMETRES
read DOSSIERURLS;
read fichier_tableau;
read motif;
echo "Le dossier d'URLs : $DOSSIERURLS " ;
echo "Le fichier contenant le tableau : $fichier_tableau" ;
echo "Le motif est : $motif" ;
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
    echo "<tr><td colspan=\"10\" align=\"center\">tableau n<sup>o</sup> $cpttableau</td></tr>" >> $fichier_tableau ;
    echo "<tr><td align=\"center\"><b>N&deg;</b></td><td align=\"center\"><b>Lien</b></td><td align=\"center\"><b>CODE CURL</b><td align=\"center\"><b>statut CURL</b></td><td align=\"center\"><b>Page Aspir&eacute;e</b></td><td align=\"center\"><b>Encodage Initial</b></td><td align=\"center\"><b>DUMP initial</b></td><td align=\"center\"><b>DUMP UTF-8</b></td><td align=\"center\"><b>CONTEXTE UTF-8</b></td><td align=\"center\"><b>Fq MOTIF</b></td></tr>" >> $fichier_tableau ;
	#-------------------------------------------------
	# traitement de chacun des URLs
    for line in `cat $DOSSIERURLS/$fichier`
	#-------------------------------------------------
	# pour chacune des lignes du fichier d'URL trait<sup>o</sup> (une URL)...
    {
		# ==> ASPIRATION DE LA PAGE
		echo "TELECHARGEMENT de $line vers ../PAGES-ASPIREES/$cpttableau-$compteur.html" ;
		# 1. RECUPERATION DU HEADER HTTP
		status1=$(curl -sI $line | head -n 1);
		# 2. RECUPERATION DU CODE RETOUR HTTP ET DE LA PAGE
		status2=$(curl --silent --output ../PAGES-ASPIREES/"$cpttableau-$compteur".html --write-out "%{http_code}" $line);
		echo "STATUT CURL : $status2" ;
		#-----------------------------------------------------------------------
		# le test de la bonne reussite du telechargement est a faire par vous...
		# si ca se passe mal, inutile de faire la suite...
		#-----------------------------------------------------------------------
		# ==> DETECTION DE L'ENCODAGE DE LA PAGE en ligne
		echo "DETECTION encodage de $line ";
        encodage=$(curl -sI $line | egrep -i "charset=" | cut -f2 -d= | tr -d "\n" | tr -d "\r" | tr "[:upper:]" "[:lower:]");
		echo "ENCODAGE $line : <$encodage>" ;
		if [[ $encodage == "utf-8" ]]
			then
				echo "DUMP de $line via lynx" ;
                lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ../DUMP-TEXT/$cpttableau-$compteur.txt ;
				# ajouter ici l'extraction de contexte autour des mots choisis
				egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur.txt > ../CONTEXTES/$cpttableau-$compteur.txt ;
				nbmotif=$(egrep -coi $motif ../DUMP-TEXT/$cpttableau-$compteur.txt);
				echo "ECRITURE RESULTAT dans le tableau" ;
				echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">lien n<sup>o</sup>$compteur</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">-</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES/$cpttableau-$compteur.txt\">CONTEXTE n<sup>o</sup> $cpttableau-$compteur</a></td><td>$nbmotif</td></tr>" >> $fichier_tableau ;
			else
				#------------------------------------------
				# ATTENTION : avant de faire ce qui suit :
				# il faudrait s'assurer que l'encodage recupere est bien un "BON" encodage !!!!
				# dans un premier temps on s'assure SEULEMENT que cette variable n'est pas vide
				# et <sup>o</sup>a ne suffit pas, il faudra modifier le code...
				#------------------------------------------
				if [[ $encodage != "" ]]
					then
						echo "DUMP (via $encodage) de $line via lynx" ;
						lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ../DUMP-TEXT/$cpttableau-$compteur.txt ;
						#------------------------------------------
						# ici il faut s'assurer que l'encodage est bien connu de iconv !!!!
						# A faire plus tard... (on regardera par exemple : iconv -l)
						#------------------------------------------
						iconv -f $encodage -t utf-8 ../DUMP-TEXT/$cpttableau-$compteur.txt > ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt
						egrep $motif ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt > ../CONTEXTES/$cpttableau-$compteur.txt ;
						nbmotif=$(egrep -coi $motif ../DUMP-TEXT/$cpttableau-$compteur.txt);
						#-------------------------------------------------------------------------------------------------------------------------
						echo "ECRITURE RESULTAT dans le tableau" ;
						echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">lien n<sup>o</sup>$compteur</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur-utf8.txt\">DUMP n<sup>o</sup> $cpttableau-$compteur</a></td><td><a href=\"../CONTEXTES/$cpttableau-$compteur.txt\">CONTEXTE n<sup>o</sup> $cpttableau-$compteur</a></td><td>$nbmotif</td></tr>" >> $fichier_tableau ;
					else
						#------------------------------------------
						# ici, on ne fait toujours rien !
						# on n'a pas detecte l'encodage
						# il faut trouver une autre solution : extraire le charset dans la page aspiree ?
						# A vous de jouer !
						#------------------------------------------
						echo "ECRITURE RESULTAT dans le tableau" ;
						echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">lien n<sup>o</sup>$compteur</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n<sup>o</sup> $cpttableau-$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">-</td><td align=\"center\">-</td><td>-</td><td>-</td></tr>" >> $fichier_tableau ;
					fi
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
