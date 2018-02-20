#!/bin/bash
read DOSSIERURLS;
read fichier_tableau;
read motif;
cpttableau=1;
echo "<html><head></head><body>" > $fichier_tableau ;
for fichier in `ls $DOSSIERURLS`
do : 
    compteur=1; 
    echo "<p align=\"center\"><hr color=\"blue\" width=\"80%\"/> </p>" >> $fichier_tableau ;
    echo "<table align=\"center\" border=\"1\">" >> $fichier_tableau ;
    echo "<tr><td colspan=\"10\" align=\"center\">tableau n° $cpttableau</td></tr>" >> $fichier_tableau ;
    echo "<tr><td align=\"center\"><b>N&deg;</b></td><td align=\"center\"><b>Lien</b></td><td align=\"center\"><b>CODE CURL</b><td align=\"center\"><b>statut CURL</b></td><td align=\"center\"><b>Page Aspir&eacute;e</b></td><td align=\"center\"><b>Encodage Initial</b></td><td align=\"center\"><b>DUMP initial</b></td><td align=\"center\"><b>DUMP UTF-8</b></td><td align=\"center\"><b>CONTEXTE UTF-8</b></td><td align=\"center\"><b>Fq MOTIF</b></td></tr>" >> $fichier_tableau ;
    for line in `cat $DOSSIERURLS/$fichier`
    do :
		status1=$(curl -sI $line | head -n 1); 
		status2=$(curl --silent --output ../PAGES-ASPIREES/"$cpttableau-$compteur".html --write-out "%{http_code}" $line);
		encodage=$(curl -sI $line | egrep -i "charset=" | cut -f2 -d= | tr -d "\n" | tr -d "\r" | tr "[:upper:]" "[:lower:]");
		if [[ $encodage == "utf-8" ]]; then
			lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ../DUMP-TEXT/$cpttableau-$compteur.txt ; 
			egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur.txt > ../CONTEXTES/$cpttableau-$compteur.txt ; 
			nbmotif=$(egrep -coi $motif ../DUMP-TEXT/$cpttableau-$compteur.txt);
			echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">$line</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n° $cpttableau-$compteur</a></td><td align=\"center\">$encodage</td><td align=\"center\">-</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n° $cpttableau-$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES/$cpttableau-$compteur.txt\">CONTEXTE n° $cpttableau-$compteur</a></td><td>$nbmotif</td></tr>" >> $fichier_tableau ;
		else :
	        if [[ $encodage != "" ]]; then
				VERIFENCODAGEDANSICONV=$(iconv -l |  egrep -o "[-A-Z0-9\_\:]+" |egrep -i $encodage) ;
				if [[ $VERIFENCODAGEDANSICONV == "" ]]; then
					echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">$line</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n° $cpttableau-$compteur</a></td><td align=\"center\">$encodage<br/>via curl<br/>inconnu de iconv</td><td align=\"center\">-</td><td align=\"center\">-</td><td>-</td><td>-</td><td>-</td></tr>" >> $fichier_tableau ;
				else :
					lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ../DUMP-TEXT/$cpttableau-$compteur.txt ;
					iconv -f $encodage -t utf-8 ../DUMP-TEXT/$cpttableau-$compteur.txt > ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt ;
					egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt > ../CONTEXTES/$cpttableau-$compteur.txt ; 
					nbmotif=$(egrep -coi $motif ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt);
					echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">$line</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n° $cpttableau-$compteur</a></td><td align=\"center\">$encodage<br/>via curl</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n° $cpttableau-$compteur</a></td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur-utf8.txt\">DUMP n° $cpttableau-$compteur</a></td><td><a href=\"../CONTEXTES/$cpttableau-$compteur.txt\">CONTEXTE n° $cpttableau-$compteur</a></td><td>$nbmotif</td></tr>" >> $fichier_tableau ;
				fi ; 
			else :
				isthereacharset=$(egrep -i -o "meta(.*)?charset" ../PAGES-ASPIREES/"$cpttableau-$compteur".html);
				if [[ $isthereacharset != "" ]]; then
					encodage=$(egrep -i -o "meta(.*)charset[^=]*?=[^\"]*?\"?[^\"]+?\"" ../PAGES-ASPIREES/$cpttableau-$compteur.html | egrep -i -o "charset[^=]*?= *?\"?[^\"]+?\"" | cut -f2 -d= | sed "s/\"//g" | sed "s/>//g" | sed "s/ //g" | sed "s/\///g" | sort -u | tr [A-Z] [a-z] );
					if [[ $encodage == "utf-8" ]]; then
						lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ../DUMP-TEXT/$cpttableau-$compteur.txt ; 
						egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur.txt > ../CONTEXTES/$cpttableau-$compteur.txt ; 
						nbmotif=$(egrep -coi $motif ../DUMP-TEXT/$cpttableau-$compteur.txt);							
						echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">$line</a></td><td align=\"center\">$status2</td><td align=\"center\"><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">P.A n° $cpttableau-$compteur</a></td><td align=\"center\">$encodage<br/>via charset</td><td align=\"center\">-</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n° $cpttableau-$compteur</a></td><td align=\"center\"><a href=\"../CONTEXTES/$cpttableau-$compteur.txt\">CONTEXTE n° $cpttableau-$compteur</a></td><td>$nbmotif</td></tr>" >> $fichier_tableau ;
					else :
						VERIFENCODAGEDANSICONV=$(iconv -l |  egrep -o "[-A-Z0-9\_\:]+" |egrep -i $encodage) ;
						if [[ $VERIFENCODAGEDANSICONV == "" ]]; then
							echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">lien n°$compteur</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n° $cpttableau-$compteur</a></td><td align=\"center\">$encodage<br/><br/>via charset<br/>inconnu de iconv</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n° $cpttableau-$compteur</a></td><td align=\"center\">-</td><td>-</td><td>-</td><td>-</td></tr>" >> $fichier_tableau ;
						else :
							lynx -dump -nolist -assume_charset=$encodage -display_charset=$encodage $line > ../DUMP-TEXT/$cpttableau-$compteur.txt ;
							iconv -f $encodage -t utf-8 ../DUMP-TEXT/$cpttableau-$compteur.txt > ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt
							egrep -i $motif ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt > ../CONTEXTES/$cpttableau-$compteur.txt ; 
							nbmotif=$(egrep -coi $motif ../DUMP-TEXT/$cpttableau-$compteur-utf8.txt);						
							echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">$line</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n° $cpttableau-$compteur</a></td><td align=\"center\">$encodage<br/>via charset</td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur.txt\">DUMP n° $cpttableau-$compteur</a></td><td align=\"center\"><a href=\"../DUMP-TEXT/$cpttableau-$compteur-utf8.txt\">DUMP n° $cpttableau-$compteur</a></td><td><a href=\"../CONTEXTES/$cpttableau-$compteur.txt\">CONTEXTE n° $cpttableau-$compteur</a></td><td>$nbmotif</td></tr>" >> $fichier_tableau ;
						fi;
					fi;
			else
				echo "<tr><td align=\"center\">$compteur</td><td align=\"center\"><a href=\"$line\">$line</a></td><td align=\"center\">$status2</td><td><small>$status1</small></td><td align=\"center\"><a href=\"../PAGES-ASPIREES/$cpttableau-$compteur.html\">PA n° $cpttableau-$compteur</a></td><td align=\"center\">Aucun encodage extrait...</td><td align=\"center\">-</td><td align=\"center\">-</td><td>-</td><td>-</td></tr>" >> $fichier_tableau ;
				fi;
			fi;
		fi; 
	let "compteur=compteur+1" ;	
    done;
    echo "</table>" >> $fichier_tableau ;
    let "cpttableau=cpttableau+1";
done
echo "</body></html>" >> $fichier_tableau ;