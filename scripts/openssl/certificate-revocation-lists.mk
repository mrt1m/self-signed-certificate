.PHONEY: create-crl

create-crl: ## CA_NAME=root.ca - create certificate revocation lists
	$(DOCKER_OPENSSL_RUN) ca -batch -gencrl \
			-config $(CA_PATH)/$(CA_NAME)/openssl.ca.cnf \
			-out $(CA_PATH)/$(CA_NAME)/crl/crl.pem \
			-passin file:$(CA_PATH)/$(CA_NAME)/pass/secret_pass
	$(DOCKER_OPENSSL_RUN) crl -in $(CA_PATH)/$(CA_NAME)/crl/crl.pem -noout -text
	[ -d $(CA_PATH)/$(CA_NAME)/root.ca ] && cat $(CA_PATH)/$(CA_NAME)/root.ca/crl/crl-chain.pem > $(CA_PATH)/$(CA_NAME)/crl/crl-chain.pem || true
	cat $(CA_PATH)/$(CA_NAME)/crl/crl.pem >> $(CA_PATH)/$(CA_NAME)/crl/crl-chain.pem
