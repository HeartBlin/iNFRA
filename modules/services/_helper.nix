{
  domain = "heartblin.eu";
  mTLS = ''
    tls {
      client_auth {
        mode require_and_verify
        trust_pool file {
          pem_file /etc/caddy/root.pem
        }
      }
    }
  '';
}
