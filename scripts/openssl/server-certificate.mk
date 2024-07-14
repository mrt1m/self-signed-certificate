.PHONY: create-server-cert

create-server-cert: ## CA_NAME=root.ca SERVER_HOST=localhost - create server cert
	cp $(CA_PATH)/$(CA_NAME)/server.ext.cnf $(CA_PATH)/$(CA_NAME)/server.$(SERVER_HOST).ext.cnf
	echo "DNS.1 = $(SERVER_HOST)" >> $(CA_PATH)/$(CA_NAME)/server.$(SERVER_HOST).ext.cnf

	$(DOCKER_OPENSSL_RUN) rand -hex -out $(CA_PATH)/$(CA_NAME)/pass/server_$(SERVER_HOST)_pass 12
	$(DOCKER_OPENSSL_RUN) genrsa -aes-256-cbc \
			-out $(CA_PATH)/$(CA_NAME)/private/server.$(SERVER_HOST).key.pem  \
			-passout file:$(CA_PATH)/$(CA_NAME)/pass/server_$(SERVER_HOST)_pass \
			2048
	$(DOCKER_OPENSSL_RUN) req -new -sha256 \
			-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
			-subj "$(SERVER_SUBJ)/OU=Server [$(SERVER_HOST)]/CN=$(SERVER_HOST)" \
			-key $(CA_PATH)/$(CA_NAME)/private/server.$(SERVER_HOST).key.pem \
			-out $(CA_PATH)/$(CA_NAME)/csr/server.$(SERVER_HOST).csr.pem \
			-passin file:$(CA_PATH)/$(CA_NAME)/pass/server_$(SERVER_HOST)_pass
	$(DOCKER_OPENSSL_RUN) ca -batch -extensions server_cert -notext -md sha256\
			-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
			-extfile $(CA_PATH)/$(CA_NAME)/server.$(SERVER_HOST).ext.cnf \
			-days $(SERVER_DAYS) \
			-in $(CA_PATH)/$(CA_NAME)/csr/server.$(SERVER_HOST).csr.pem \
			-out $(CA_PATH)/$(CA_NAME)/certs/server.$(SERVER_HOST).cert.pem \
            -passin file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass
	$(DOCKER_OPENSSL_RUN) verify -CAfile $(CA_PATH)/$(CA_NAME)/certs/ca-chain.cert.pem \
          $(CA_PATH)/$(CA_NAME)/certs/server.$(SERVER_HOST).cert.pem
