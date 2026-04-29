# 🛠️ Life-Saver Guide: Ved Ny IP-adresse

Denne guide bruges, når IP-adressen på ChirpStack-serveren (din PC) ændres, og TLS-forbindelsen til gatewayen derfor knækker.

---

### 1. Opdater konfigurationsfiler (PC)
Gå til mappen: `chirpstack-docker/configuration/certs`

* **mqtt-server-csr.json**: Ret IP-feltet til den nye adresse.
* **extfile.cnf**: Ret IP-adressen i linjen `subjectAltName` (behold `localhost` og `127.0.0.1`).

### 2. Opdater Gatewayens "Telefonbog" (Gateway)
Gatewayen skal vide, at navnet `mqtt.local` nu peger på den nye IP.

1.  SSH ind i gatewayen: `ssh root@[gateway_ip]`
2.  Åbn hosts-filen: `vi /etc/hosts`
3.  Ret IP'en ud for `mqtt.local` til din PCs **nye IP**.
4.  Gem og afslut: Tryk `Esc`, skriv `:wq` og tryk `Enter`.

### 3. Generer nyt certifikat & genstart (PC)
Nu udstedes et nyt certifikat til Mosquitto, der er gyldigt til den nye IP.

```bash
# Signer det nye certifikat med din eksisterende CA
openssl x509 -req -in mqtt-server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out mqtt-server.pem -days 365 -extfile extfile.cnf

# Genstart Mosquitto-containeren
docker-compose restart mosquitto
