#!/bin/bash


read DOSSIER;
cd $DOSSIER;

#cat *.txt > concat.txt;


for fichier in `ls $DOSSIER`
{
    echo "" > concat.txt
    cat $fichier >> concat.txt
}