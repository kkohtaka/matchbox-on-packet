#!/usr/bin/env bash
# This file is originally developed by CoreOS, Inc. on the project:
#   https://github.com/coreos/matchbox
# and licensed under Apache License 2.0.:
#   http://www.apache.org/licenses/LICENSE-2.0

# note: Script uses -batch and -subj, instead of interactive prompts.
set -e

outdir=$PWD/.matchbox
tmpdir=$PWD/tmp

rm -rf $tmpdir
mkdir -p $tmpdir
cp $(dirname $0)/openssl.conf $tmpdir/
pushd $tmpdir

rm -f ca.key ca.crt server.key server.csr server.crt client.key client.csr client.crt index.* serial*
rm -rf certs crl newcerts

if [ -z $SAN ]
  then echo "Set SAN with a DNS or IP for matchbox (e.g. export SAN=DNS.1:matchbox.example.com,IP.1:192.168.1.42)."
  exit 1
fi

echo "Creating example CA, server cert/key, and client cert/key..."

# basic files/directories
mkdir -p {certs,crl,newcerts}
touch index.txt
touch index.txt.attr
echo 1000 > serial

# CA private key (unencrypted)
openssl genrsa -out $outdir/ca.key 4096
# Certificate Authority (self-signed certificate)
openssl req -config openssl.conf -new -x509 -days 3650 -sha256 -key $outdir/ca.key -extensions v3_ca -out $outdir/ca.crt -subj "/CN=fake-ca"

# End-entity certificates

# Server private key (unencrypted)
openssl genrsa -out $outdir/server.key 2048
# Server certificate signing request (CSR)
openssl req -config openssl.conf -new -sha256 -key $outdir/server.key -out server.csr -subj "/CN=fake-server"
# Certificate Authority signs CSR to grant a certificate
openssl ca -batch -config openssl.conf -extensions server_cert -days 365 -notext -md sha256 -in server.csr -out $outdir/server.crt -cert $outdir/ca.crt -keyfile $outdir/ca.key

# Client private key (unencrypted)
openssl genrsa -out $outdir/client.key 2048
# Signed client certificate signing request (CSR)
openssl req -config openssl.conf -new -sha256 -key $outdir/client.key -out client.csr -subj "/CN=fake-client"
# Certificate Authority signs CSR to grant a certificate
openssl ca -batch -config openssl.conf -extensions usr_cert -days 365 -notext -md sha256 -in client.csr -out $outdir/client.crt -cert $outdir/ca.crt -keyfile $outdir/ca.key

# Remove CSR's
rm *.csr

echo "*******************************************************************"
echo "WARNING: Generated credentials are self-signed. Prefer your"
echo "organization's PKI for production deployments."

popd
