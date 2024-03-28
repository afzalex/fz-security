# How to Use

You should have git and docker installed in your system.


Run following command

```sh
./install
```

Restart terminal and then run following command

```sh
fzsecure
```

Now you are inside fzsecure terminal   

To setup a directory where you want to encrypt or decrypt your data
run following command

```sh
init
```
then provide password to use to encrypt/decrypt data   

To encrypt any data use following command
```sh
encrypt "filename_to_encrypt.txt"
```

Now you can delete original file, i.e. in this case "filename_to_encrypt.txt".    
You can keep *.pem file and keys directory in safe location.   

To decrypt data back, use below command.

```sh
decrypt "filename_to_encrypt.txt.omega"
```

Anytime when you want to exit from fzsecure enter exit.

```sh
exit
```