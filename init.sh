#!/bin/bash

# Initialize the password variables
password=""
password_confirm=""

# Prompt for the password and its confirmation until they match
while true; do
    read -s  -p "Enter your password: " password
    echo ""
    read -s -p "Confirm your password: " password_confirm
    echo ""

    # Check if passwords match
    if [ "$password" = "$password_confirm" ]; then
        echo "Password Matched"
        break # Exit the loop if passwords match
    else
        echo "Passwords do not match. Please try again."
    fi
done

# Export the password as an environment variable for the current session
export MY_PASSWORD="$password"

export MY_PASSWORD
echo Creating rsa pairs
openssl genrsa -aes256 -passout env:MY_PASSWORD -out rsa_key_aes256.pem 10240
openssl rsa -pubout -in rsa_key_aes256.pem -out rsa_key_aes256.pub -passin env:MY_PASSWORD
unset MY_PASSWORD

SCRIPT_LINK=$(realpath "$0")
SCRIPT_DIR=$(dirname "$SCRIPT_LINK")

cp "${SCRIPT_DIR}/default_omega_crypto.txt" ./
encrypt default_omega_crypto.txt