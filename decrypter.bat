@echo off

set DEFAULT_TO_DECRYPT=default_omega_crypto.txt.omega
set OMEGA_TEMP_LOC=%temp%\omega
set KEY_TEMP_FILE=%OMEGA_TEMP_LOC%\omega_key_temp.dat
set KEYS_LOC=keys
set DEFAULT_RSA_PRIVATEKEY=rsa_key_aes256.pem
set CYPHER_ALGO=aes-256-cbc

if not exist "%KEYS_LOC%" (
	md %KEYS_LOC%
)

if not exist "%OMEGA_TEMP_LOC%" (
	md "%OMEGA_TEMP_LOC%"
)

set /p todecrypt=File to decrypt     : 

if "%todecrypt%" == "" (
	echo Taking %DEFAULT_TO_DECRYPT% as file to decrypt
	set todecrypt=%DEFAULT_TO_DECRYPT%
)

if "%todecrypt:~-6%" == ".omega" (
	set isomega=Y
	set key=%KEYS_LOC%\%todecrypt:~0,-6%.key
)

if not exist "%key%" (
	set /p key=Key to decrypt      : 
)


if exist "%DEFAULT_RSA_PRIVATEKEY%" (
	set rsapublickey=%DEFAULT_RSA_PRIVATEKEY%
) else (
	set /p rsapublickey=Private key file    : 
)

if exist "%KEY_TEMP_FILE%" del "%KEY_TEMP_FILE%"
openssl rsautl -in %key% -inkey %rsapublickey% -decrypt -out "%KEY_TEMP_FILE%" 2> NUL

if exist "%KEY_TEMP_FILE%" (
	goto decrypt 
) else (
	echo Either you typed invalid password or some error occured. Go to hell now.
	goto end
)

:decrypt
set response=Y
set /p response=Print output [Y]?   : 

if "%response%" == "Y" (
	echo -------------------------------------------------------------------
	openssl %CYPHER_ALGO% -pbkdf2 -iter 10000 -in "%todecrypt%" -d -pass file:"%KEY_TEMP_FILE%"
	echo.
	echo -------------------------------------------------------------------
	goto end
)

if "%isomega%" == "Y" (
	set outputfile="%todecrypt:~0,-6%"
) else (
	set /p outputfile=Output file         : 
)

openssl %CYPHER_ALGO% -pbkdf2 -iter 10000 -in "%todecrypt%" -d -pass file:"%KEY_TEMP_FILE%" -out "%outputfile%"

:end
pause
