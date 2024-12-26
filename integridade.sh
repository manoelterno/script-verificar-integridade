#!/bin/bash

criar(){
  for arquivo in $(find $diretorio -type f ); do
  md5=$(md5sum $arquivo | awk -F" " '{print $1}')
  echo "$arquivo:$md5" >> ./hash.txt
  done
}

verificar(){
  for arquivo in $(find $diretorio -type f ); do
    if [ $(grep -ic $arquivo ./hash.txt) -eq 1 ] 
    then
      
      hashOriginal=$(cat hash.txt | grep $arquivo | awk -F":" '{print $2}')
      hashAtual=$(md5sum $arquivo | awk -F" " '{print $1}')
      
      arquivo_escapado=$(echo "$arquivo" | sed 's/[\/&]/\\&/g')

      if [ "$hashAtual" != "$hashOriginal" ]
      then
        sed -i "s/$arquivo_escapado:$hashOriginal/$arquivo_escapado:$hashAtual/" hash.txt
        echo $(grep $arquivo hash.txt)
      fi
    else
      md5=$(md5sum $arquivo | awk -F" " '{print $1}')
      echo "$arquivo:$md5" >> ./hash.txt
    fi
  done
}

diretorio=$1

FILE=./hash.txt
if [[ -f $FILE ]]; then
  verificar
else
  criar
fi

