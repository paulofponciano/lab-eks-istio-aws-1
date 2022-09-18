#!/bin/bash

# Gets input from stdin, store it in a variable to allow it to be used multiple times
input=$(cat)

# Parse the input JSON with sed to find the value for the terraform variable key
region="$(sed -r -e 's|^.*"region":"(.*)?".*?$|\1|g' <<< $input)"


THUMBPRINT=$(echo | openssl s_client -servername oidc.eks.${region}.amazonaws.com -showcerts -connect oidc.eks.${region}.amazonaws.com:443 2>&- | tac | sed -n '/-----END CERTIFICATE-----/,/-----BEGIN CERTIFICATE-----/p; /-----BEGIN CERTIFICATE-----/q' | tac | openssl x509 -fingerprint -noout | sed 's/://g' | awk -F= '{print tolower($2)}')
THUMBPRINT_JSON="{\"thumbprint\": \"${THUMBPRINT}\"}"
echo ${THUMBPRINT_JSON}