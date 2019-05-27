#!/bin/bash
DNS_COUNTER=0
IP_COUNTER=0
NEXT=0
cat >$PWD/openssl.cnf <<EOL
[ req ]
prompt = no
default_bits = 4096
distinguished_name = req_distinguished_name
req_extensions = req_ext

[ req_distinguished_name ]
C=ES
O=Keynetic Technologies
OU=${1}
CN=${2}

[ req_ext ]
subjectKeyIdentifier=hash
basicConstraints = critical,CA:false
EOL

if [ $3 = "--SAN" ]
then
    cat >>$PWD/openssl.cnf <<EOL
subjectAltName = @alt_names


[alt_names]
EOL
fi
for ((i = 4; i <= $#; i++ )); do
    if [ ${!i} = "--DNS"  ]; 
    then

    NEXT=$((i+1))
    DNS_COUNTER=$((DNS_COUNTER+1))
    cat >>$PWD/openssl.cnf <<EOL
DNS.${DNS_COUNTER}=${!NEXT}
EOL
        #NEXT=$((i+1))
        #echo ${!NEXT}
        #echo ${!i}
    
    elif [  ${!i} = "--IP"  ]; 
    then

    NEXT=$((i+1))
    IP_COUNTER=$((IP_COUNTER+1))
    cat >>$PWD/openssl.cnf <<EOL
IP.${IP_COUNTER}=${!NEXT}
EOL
    fi

    #printf '%s\n' "Arg $i: ${!i}"
done

mkdir $PWD/${1}/
cat $PWD/openssl.cnf
mv $PWD/openssl.cnf $PWD/${1}/
cd $PWD/${1}/
openssl genrsa -out private.key 2048
openssl req -new -key private.key -config openssl.cnf -out ${1}.csr



