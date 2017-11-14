#!/bin/bash

# File to crypt
UNCFILE=$1
# Public key of the recipient
PUBKEY=$2

# Create 256-bit symmetric key
openssl rand -base64 32 > key.bin
# Encrypt the file
openssl aes-256-cbc -in $UNCFILE -a -out $UNCFILE.enc -pass file:key.bin 
# Encrypt the key
openssl rsautl -encrypt -oaep -pubin -inkey <(ssh-keygen -e -f $PUBKEY -m PKCS8) -in key.bin  -out secret.key.enc
base64 secret.key.enc > secret.key.txt

# Show the encrypted ascii strings
echo "KEY"
cat secret.key.txt
echo "FILE"
cat $UNCFILE.enc

# Remove stuff --> Lose message, access to it, lose the symmetric key, etc.
# For better security, one should do a deep removal rewriting the disk to erase properly the file
# Or not write files at all: investigate the option of opening buffers at runtime and acting on them on the fly
rm $UNCFILE
rm $UNCFILE.enc
rm key.bin
rm secret.key.enc
rm secret.key.txt


