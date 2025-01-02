#!/bin/bash
criar(){
  for arquivo in $(find $diretorio -type f ); do
  md5=$(md5sum $arquivo | awk -F" " '{print $1}')
  echo "$arquivo:$md5" >> $arquivo_hash
  done
  chmod 600 "$arquivo_hash"
}
verificar(){
  for arquivo in $(find $diretorio -type f ); do
    if [ $(grep -ic $arquivo $arquivo_hash) -eq 1 ] 
    then
      hashOriginal=$(cat $arquivo_hash | grep $arquivo | awk -F":" '{print $2}')
      hashAtual=$(md5sum $arquivo | awk -F" " '{print $1}')
      arquivo_escapado=$(echo "$arquivo" | sed 's/[\/]/\\&/g')
      if [ "$hashAtual" != "$hashOriginal" ]
      then
        sed -i "s/$arquivo_escapado:$hashOriginal/$arquivo_escapado:$hashAtual/" $arquivo_hash
        echo $(grep $arquivo $arquivo_hash)
      fi
    else
      md5=$(md5sum $arquivo | awk -F" " '{print $1}')
      echo "$arquivo:$md5" >> $arquivo_hash
    fi
  done
  for linha in $(cat $arquivo_hash); do
    arquivo_temp=$(echo "$linha" | sed 's/\(.*\):.*/\1/')
    if [ $(find $diretorio | grep -ic $arquivo_temp) -ne 1 ]; then
      echo "$linha"
    fi
  done
}
diretorio=${1:? Necessario fornecer um diretorio}
arquivo_hash="./hash_$(echo "$diretorio" | sed 's/[\/]/_/g').txt"
if [[ -f $arquivo_hash ]]; then
  verificar
else
  criar
fi

