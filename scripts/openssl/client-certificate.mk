.PHONY: create-client-cert revoke-client-cert export-client-cert

create-client-cert: ## CA_NAME=root.ca CLIENT_EMAIL=user@lol.kek - create client certificate
	$(DOCKER_OPENSSL_RUN) genrsa -out $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem 2048
	$(DOCKER_OPENSSL_RUN) req -new -batch \
			-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
			-subj "$(CLIENT_SUBJ)/CN=$(CLIENT_EMAIL)" \
			-days $(CLIENT_DAYS) \
			-key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem \
			-out $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).csr.pem
	$(DOCKER_OPENSSL_RUN) ca -batch -extensions usr_cert -notext -md sha256 \
			-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
			-in $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).csr.pem \
			-out $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem \
            -passin file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass

revoke-client-cert: ## CA_NAME=root.ca CLIENT_EMAIL=user@lol.kek - revoke client certificate
	$(DOCKER_OPENSSL_RUN) ca -config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
            -revoke $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem \
            -passin file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass

export-client-cert: ## CA_NAME=root.ca CLIENT_EMAIL=user@lol.kek EXPORT_CLIENT_PASS=123123 - export client certificate to pkcs12 format
	$(DOCKER_OPENSSL_RUN) pkcs12 -export -legacy -name $(CLIENT_EMAIL) \
            -in $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem \
            -inkey $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem \
            -out $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).pfx \
            -passout pass:$(EXPORT_CLIENT_PASS)
