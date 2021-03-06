#!/bin/bash


# Encrypted symmetric key
SKEY=$1
# Encrypted message
MSG=$2
# Your secret key
KEY=$3

base64 --decode $SKEY > $SKEY.bin
# Decrypt the symmetric key 
openssl rsautl -decrypt -oaep -inkey $KEY -in $SKEY.bin -out symkey.key

# Decrypt the message to stdout
openssl aes-256-cbc -a -d -in $MSG -pass file:symkey.key

# Remove the symmetric key, as it is supposed to be used one time only
# Again, all these removals should be done with a disk-rewriting tool, not with just rm
rm $SKEY
rm $SKEY.bin
rm symkey.key
# Remove the encrypted message 
rm $MSG
# Warn user
echo "WARNING: DO NOT REUSE THE SYMMETRIC KEY. It would be a deeply insecure practice."
