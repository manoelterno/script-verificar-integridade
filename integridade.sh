#!/bin/bash

criar(){
#limpando e criando  hash.txt#
> ./hash.txt

quantArquivos=$(ls $diretorio -1 |  wc -l)
i=1

while [ $i -le $quantArquivos ]
do
 arquivo=$(ls $diretorio -l | tail -n +2 | awk -F" " '{print $9}' | head -$i | tail +$i)
 md5=$(md5sum $diretorio/$arquivo | awk -F" " '{print $2":"$1}')
 data=$(date +"%d/%m/%Y")
 echo "$md5:$data" >> ./hash.txt
 i=$((i+1))
done
}

verificar() {
quantArquivos=$(ls $diretorio -1 |  wc -l)
i=1
while [ $i -le $quantArquivos ]
do
 arquivo=$(ls $diretorio -l | tail -n +2 | awk -F" " '{print $9}' | head -$i | tail +$i)
 hashOriginal=$(cat ./hash.txt | head -$i | tail +$i | awk -F":" '{print $2}')
 hashAtual=$(md5sum $diretorio/$arquivo | awk -F" " '{print $1}')
 if [ $hashAtual == $hashOriginal ]; then
    i=$((i+1))
    continue
 else
    #divergencia encontrada
    data=$(date +"%d/%m/%Y")
    novaLinha="$diretorio/$arquivo:$hashAtual:$data"
    sed -i "/$arquivo/c\\$novaLinha" hash.txt
 fi
 i=$((i+1))
done
}



#substituir diretorio/ por diretorio
diretorio=${1///}

FILE=./hash.txt
if [[ -f $FILE ]]; then
  echo "arquivo existe"
  verificar
else
  echo "arquivo nao existe"
  criar
fi

