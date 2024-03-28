#!/bin/bash

DEFAULT_TO_ENCRYPT=default_omega_crypto.txt
CYPHER_KEY_LENGTH=1024
CYPHER_ALGO=aes-256-cbc
OMEGA_TEMP_LOC=/tmp/omega
KEY_TEMP_FILE=${OMEGA_TEMP_LOC}/omega_key_temp.dat
DEFAULT_RSA_PUBLICKEY=rsa_key_aes256.pub
KEYS_LOC=keys

if [ ! -e "${KEYS_LOC}" ]; then
	mkdir "${KEYS_LOC}";
fi;

if [ ! -e "${OMEGA_TEMP_LOC}" ]; then
	mkdir "${OMEGA_TEMP_LOC}";
fi;

if [ $# -eq 0 ]; then
	read -e -p "File to encrypt [${DEFAULT_TO_ENCRYPT}]: " toencrypt
else
	toencrypt="$1"
fi


if [ "${toencrypt}" == "" ]; then
	toencrypt=${DEFAULT_TO_ENCRYPT};
	echo ${DEFAULT_TO_ENCRYPT} is taken as file to encrypt;
fi;

if [ -e "${DEFAULT_RSA_PUBLICKEY}" ]; then
	rsapublickey=${DEFAULT_RSA_PUBLICKEY};
else
	read -e -p "Public key file: " rsapublickey;
fi;

# Creating key
openssl rand ${CYPHER_KEY_LENGTH} > ${KEY_TEMP_FILE};

# Encrypting file with created key
openssl ${CYPHER_ALGO} -pbkdf2 -iter 10000 -in "${toencrypt}" -out "${toencrypt}.omega" -pass file:"${KEY_TEMP_FILE}"

# Encrypting key
openssl pkeyutl -in "${KEY_TEMP_FILE}" -out "${KEYS_LOC}/${toencrypt}.key" -inkey "${rsapublickey}" -pubin -encrypt

rm "${KEY_TEMP_FILE}"
