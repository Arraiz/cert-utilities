#!/usr/bin/env bash
#Created by Mikel Diez (Arraiz) https://github.com/Arraiz
# Supose we have the root CA  CLCA in /home/keynetic/THE-ROOT-CA/
CAPATH="$PWD/$CANAME"
CACSR="$CANAME.csr"
no_hsm() {
    read -p "Enter the SubCA name: "  CANAME
    echo "Creating $CANAME CA in $CAPATH$CANAME"
    
    #Antes de continuar doblechckear que todo es correcto
    git clone https://github.com/openxpki/clca
    mv clca $CANAME
 if [ -d "$CANAME" ]; then
    
    
    echo "copiando ficheros clca.cfg y openssl.cfg"
    cp -r $CAPATH/$CANAME/etc $CAPATH/$CANAME/bin
    cd $CAPATH/$CANAME/bin
    chmod +x clca
    # Create the key
    mkdir $PWD/private
    openssl genrsa -out $PWD/private/cakey.pem 2048 -config $PWD/bin/etc/openssl.cnf
    #create the CSR
    echo generating the csr...
    CACSR="$CANAME.csr"
    ./clca initialize --req "$CACSR"
    # issue the certificate in the other CA
else
    echo "was a problem creating the ca"
    exit
fi
}

if [ "$UID" = "0" ]; then
    echo "Do not run this as root."
    exit
fi

#Check if is an HSM CA
while true; do
    read -p "is an HSM subCA[y/n default=y]?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) no_hsm; break;;
        * ) echo "Please answer yes or no.";;
    esac
done







