# Encrypting data
	- put the file you want to encrypt (source_file) in current directory
	- Run encrypter script
		- Windows
			> encrypter.bat
		- Linux
			$ ./encrypter.bat
	- A prompt will appear. Enter location of source file here. (source_file)
		File to encrypt [default_omega_crypto.txt] : 
	- If you don't provide file name then default_omega_crypto.txt will be taken as source file
	- If no conflicting message appeared the file is encrypted succefully.
	- The name of encrypted file will be same as source file with '.omega' extension. e.g.
		source_file.omega
	- A key will be created in ./keys/ directory which will be used later to decrypt the encrypted file
	- The name of that key will be same as decryped file with '.key' extension. e.g.
		source_file.omega.key

# Creation of private rsa key 
	- Name of the created private rsa file should be "rsa_key_aes256.pem"
	- Preffered size of rsa key is 10240
	- Encryption algorigthm should be aes256
		$ openssl genrsa -aes256 -out rsa_key_aes256.pem 10240;
	- Remember password that was given to create rsa key.

# Creation of public rsa key
	- Name of the created public rsa file should be "rsa_key_aes256.pub"
		$ openssl rsa -pubout -in rsa_key_aes256.pem -out rsa_key_aes256.pub 
