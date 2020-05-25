# mkcert

A Docker container for generating TLS certificates for local development environments.

The `mkcert` binary writes the certificate files to `/root/.local/share/mkcert`.


## Docker Compose Example

Use the following container definition to generate a certificate for `example.test` and its subdomains. Note that mkcert supports only one level wildcards.

The generated certificates are used by the `nginx-proxy` container to enable [TLS support](https://github.com/nginx-proxy/nginx-proxy/tree/3cbc5417b7ac38037a9ec00fe80e0996d7da3d75#ssl-support).

```yaml
version: '2'

services:

  mkcert:
    image: wpsh/mkcert
    volumes:
      - cert_data:/root/.local/share/mkcert
    command: mkcert -cert-file "example.test.crt" -key-file "example.test.key" "example.test" "*.example.test"

  nginx-proxy:
    image: jwilder/nginx-proxy
    depends_on:
      - mkcert
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - cert_data:/etc/nginx/certs
      - /var/run/docker.sock:/tmp/docker.sock:ro

volumes:
  cert_data: {}
```
