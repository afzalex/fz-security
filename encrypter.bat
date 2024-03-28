@echo off

set DEFAULT_TO_ENCRYPT=default_omega_crypto.txt
set CYPHER_KEY_LENGTH=1024
set CYPHER_ALGO=aes-256-cbc
set OMEGA_TEMP_LOC=%temp%\omega
set KEY_TEMP_FILE=%OMEGA_TEMP_LOC%\omega_key_temp.dat
set DEFAULT_RSA_PUBLICKEY=rsa_key_aes256.pub
set KEYS_LOC=keys

if not exist "%KEYS_LOC%" (
	md %KEYS_LOC%
)

if not exist "%OMEGA_TEMP_LOC%" (
	md "%OMEGA_TEMP_LOC%"
)

set /p toencrypt=File to encrypt : 

if "%toencrypt%" == "" (
	echo %DEFAULT_TO_ENCRYPT% is taken as file to encrypt
	set toencrypt=%DEFAULT_TO_ENCRYPT%
)

if exist "%DEFAULT_RSA_PUBLICKEY%" (
	set rsapublickey=%DEFAULT_RSA_PUBLICKEY%
) else (
	set /p rsapublickey=Public key file : 
)

rem creating key
openssl rand %CYPHER_KEY_LENGTH% > %KEY_TEMP_FILE%

rem encrypting file with created key
openssl %CYPHER_ALGO% -pbkdf2 -iter 10000 -in "%toencrypt%" -out "%toencrypt%.omega" -pass file:"%KEY_TEMP_FILE%"

rem encrypting key
openssl pkeyutl -in "%KEY_TEMP_FILE%" -out "%KEYS_LOC%\%toencrypt%.key" -inkey "%rsapublickey%" -pubin -encrypt

del %KEY_TEMP_FILE%