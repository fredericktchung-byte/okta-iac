const crypto = require('crypto');
const fs = require('fs');

// 1. Read the public key from your local file
const publicKeyPem = fs.readFileSync('../tines_public.pem', 'utf8');

// 2. Parse the key using Node's native cryptography module
const publicKey = crypto.createPublicKey(publicKeyPem);

// 3. Export it precisely into the JWK format Okta requires
const jwk = publicKey.export({ format: 'jwk' });

// 4. Print the output to your terminal
console.log(JSON.stringify(jwk, null, 2));