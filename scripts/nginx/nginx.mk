.PHONY: nginx-init-certs

nginx-init-certs: ## CA_NAME=root.ca SERVER_HOST=localhost - prepare nginx certificates
	rm -rf ./nginx/ssl

	mkdir ./nginx/ssl

	cp $(CA_PATH)/$(CA_NAME)/certs/ca-chain.cert.pem ./nginx/ssl
	cp $(CA_PATH)/$(CA_NAME)/crl/crl-chain.pem ./nginx/ssl

	cp $(CA_PATH)/$(CA_NAME)/certs/server.$(SERVER_HOST).cert.pem ./nginx/ssl
	cp $(CA_PATH)/$(CA_NAME)/private/server.$(SERVER_HOST).key.pem ./nginx/ssl

	cp $(CA_PATH)/$(CA_NAME)/pass/server_$(SERVER_HOST)_pass ./nginx/ssl
