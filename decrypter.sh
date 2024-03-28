#!/bin/bash

DEFAULT_TO_DECRYPT=default_omega_crypto.txt.omega
OMEGA_TEMP_LOC=/tmp/omega
KEY_TEMP_FILE=${OMEGA_TEMP_LOC}/omega_key_temp.dat
KEYS_LOC=keys
DEFAULT_RSA_PRIVATEKEY=rsa_key_aes256.pem
CYPHER_ALGO=aes-256-cbc

if [ ! -e "${KEYS_LOC}" ]; then
    mkdir "$KEYS_LOC";
fi;

if [ ! -e "${OMEGA_TEMP_LOC}" ]; then
	mkdir "${OMEGA_TEMP_LOC}";
fi;



if [ $# -eq 0 ]; then
	read -e -p "File to decrypt [${DEFAULT_TO_DECRYPT}]: " todecrypt;
else
	todecrypt="$1"
fi

if [ "${todecrypt}" == "" ]; then
	todecrypt=${DEFAULT_TO_DECRYPT};
	echo Taking ${DEFAULT_TO_DECRYPT} as file to decrypt;
fi;

if [ "${todecrypt: -6}" == ".omega" ]; then
	isomega=Y;
	key=${KEYS_LOC}/${todecrypt:0:${#todecrypt}-6}.key;
fi;

if [ ! -e "${key}" ]; then
	read -e -p "Key to decrypt: " key;
fi;


if [ -e "${DEFAULT_RSA_PRIVATEKEY}" ]; then
	rsapublickey=${DEFAULT_RSA_PRIVATEKEY};
else
	read -e -p "Private key file: " rsapublickey;
fi;

if [ -e "${KEY_TEMP_FILE}" ]; then rm "$KEY_TEMP_FILE"; fi;
openssl rsautl -in "${key}" -inkey ${rsapublickey} -decrypt -out "${KEY_TEMP_FILE}" 2> /dev/null

if [ -e "${KEY_TEMP_FILE}" ]; then
	read -p "Print output [Y] ? " response;
	if [ "${response}" == "" ]; then
		response=Y;
	fi;
	if [ "${response}" == "Y" ]; then
		echo -------------------------------------------------------------------;
		openssl ${CYPHER_ALGO} -pbkdf2 -iter 10000 -in "${todecrypt}" -d -pass file:${KEY_TEMP_FILE}
		echo "";
		echo -------------------------------------------------------------------;
		exit;
	fi;
	if [ "${isomega}" == "Y" ]; then
		outputfile=${todecrypt:0:${#todecrypt}-6};
	else
		read -e -p "Output file: " outputfile;
	fi;
	openssl ${CYPHER_ALGO} -pbkdf2 -iter 10000 -in "${todecrypt}" -d -pass file:"${KEY_TEMP_FILE}" -out "${outputfile}"
else
	echo Either you typed invalid password or some error occured. Go to hell now.
fi;

