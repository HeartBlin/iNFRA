{ inputs, ... }:

{
  services.caddy.virtualHosts."whoami.${inputs.stigmata.constants.domain}".extraConfig = ''
    ${inputs.stigmata.constants.mTLS}
    header Content-Type text/plain
    respond <<TEXT
    Connection
      Remote:      {http.request.remote}
      Client IP:   {client_ip}
      Proto:       {http.request.proto}  (ALPN: {http.request.tls.proto})
      Resumed:     {http.request.tls.resumed}

    TLS
      Version:     {http.request.tls.version}
      Cipher:      {http.request.tls.cipher_suite}
      SNI:         {http.request.tls.server_name}

    Client cert
      Subject:     {http.request.tls.client.subject}
      Issuer:      {http.request.tls.client.issuer}
      Serial:      {http.request.tls.client.serial}
      Fingerprint: {http.request.tls.client.fingerprint}
    TEXT
  '';
}
