.PHONEY: init-ca init-ca-config create-root-ca-cert create-intermediate-ca

init-ca: ## CA_NAME=root.ca OPENSSL_CONFIG_NAME=openssl.root.ca.cnf OPENSSL_SERVER_EXT_NAME=server.ext.cnf - init CA directories
	rm -rf $(CA_PATH)/$(CA_NAME)
	mkdir -p $(CA_PATH)/$(CA_NAME)/new_certs $(CA_PATH)/$(CA_NAME)/crl $(CA_PATH)/$(CA_NAME)/certs $(CA_PATH)/$(CA_NAME)/private $(CA_PATH)/$(CA_NAME)/clients $(CA_PATH)/$(CA_NAME)/csr $(CA_PATH)/$(CA_NAME)/pass
	touch $(CA_PATH)/$(CA_NAME)/index.txt $(CA_PATH)/$(CA_NAME)/serial $(CA_PATH)/$(CA_NAME)/crlnumber
	echo 01 > $(CA_PATH)/$(CA_NAME)/serial
	echo 1000 > $(CA_PATH)/$(CA_NAME)/crl_number
	mkdir -p $(CA_PATH)/$(CA_NAME)/csr
	$(DOCKER_OPENSSL_RUN) rand -hex -out $(CA_PATH)/$(CA_NAME)/pass/secret_pass 1024
	make init-ca-config

init-ca-config: ## CA_NAME=root.ca OPENSSL_CONFIG_NAME=openssl.root.ca.cnf OPENSSL_SERVER_EXT_NAME=server.ext.cnf - init CA config
	echo "dir=$(CA_PATH)/$(CA_NAME)" > $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf
	cat $(OPENSSL_CONFIG_PATH)/$(OPENSSL_CONFIG_NAME) >> $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf
	cp $(OPENSSL_CONFIG_PATH)/$(OPENSSL_SERVER_EXT_NAME) $(CA_PATH)/$(CA_NAME)/server.ext.cnf

create-root-ca-cert: ## CA_NAME=root.ca - create root CA certificate
	$(DOCKER_OPENSSL_RUN) genrsa -aes-256-cbc -out $(CA_PATH)/$(CA_NAME)/private/ca.key.pem -passout file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass 4096
	$(DOCKER_OPENSSL_RUN) req -new -x509 -sha256 -extensions v3_ca \
				-subj "$(ROOT_CA_SUBJ)" \
				-days $(ROOT_CA_DAYS) \
				-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
				-key $(CA_PATH)/$(CA_NAME)/private/ca.key.pem \
				-out $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem \
				-passin file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass
	$(DOCKER_OPENSSL_RUN) x509 -noout -text -in $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem
	cat $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem > $(CA_PATH)/$(CA_NAME)/certs/ca-chain.cert.pem

create-intermediate-ca: ## CA_NAME=intermediate.root.ca ROOT_CA_NAME=root.ca - create intermediate CA certificate
	ln -s ../$(ROOT_CA_NAME) $(CA_PATH)/$(CA_NAME)/root.ca
	$(DOCKER_OPENSSL_RUN) genrsa -aes-256-cbc \
			-out $(CA_PATH)/$(CA_NAME)/private/ca.key.pem \
			-passout file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass 4096
	$(DOCKER_OPENSSL_RUN) req -new -sha256 \
			-subj "$(INTERMEDIATE_CA_SUBJ)/CN=$(CA_NAME)" \
			-days $(INTERMEDIATE_CA_DAYS) \
			-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
			-key $(CA_PATH)/$(CA_NAME)/private/ca.key.pem \
			-out $(CA_PATH)/$(CA_NAME)/csr/ca.csr.pem \
			-passin file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass
	$(DOCKER_OPENSSL_RUN)  ca -notext -batch -md sha256 -extensions v3_intermediate_ca \
			-config $(CA_PATH)/$(CA_NAME)/root.ca/openssl.ca.cnf \
			-in $(CA_PATH)/$(CA_NAME)/csr/ca.csr.pem \
			-out $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem \
			-passin file:$(CA_PATH)/$(CA_NAME)/root.ca/pass/secret_pass
	cat $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem $(CA_PATH)/$(CA_NAME)/root.ca/certs/ca-chain.cert.pem > $(CA_PATH)/$(CA_NAME)/certs/ca-chain.cert.pem
