.PHONY: test-https test-client_verify test-revoke_client_cert

URL=https://localhost

test-https: ## CA_NAME=root.ca URL=https://localhost - test https
	@echo "curl $(URL) -s -o /dev/null -w %{http_code}"
ifeq ($(shell curl $(URL) -s -o /dev/null -w %{http_code}), 000)
	@echo "test https request with CA cert - OK"
else
	@echo "test https request with CA cert - fail"
endif
	@echo "curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem"
ifeq ($(shell curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem), 200)
	@echo "test https request without CA cert - OK"
else
	@echo "test https request without CA cert - fail"
endif

test-client_verify: ## CA_NAME=root.ca URL=https://localhost/protection-magic/ CLIENT_EMAIL=user@lol.kek
	@echo "curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem --cert $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem --key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem"
ifeq ($(shell curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem --cert $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem --key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem), 200)
	@echo "test request with client cert - OK"
else
	@echo "test request with client cert - fail"
endif
	@echo "curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem --key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem"
ifeq ($(shell curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem --key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem), 403)
	@echo "test request without client cert - OK"
else
	@echo "test request without client cert - fail"
endif

test-revoke_client_cert: ## CA_NAME=root.ca URL=https://localhost/protection-magic/ CLIENT_EMAIL=user@lol.kek
	@echo "curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem --cert $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem --key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem"
ifeq ($(shell curl $(URL) -s -o /dev/null -w %{http_code} --cacert $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem --cert $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).cert.pem --key $(CA_PATH)/$(CA_NAME)/clients/$(CLIENT_EMAIL).key.pem), 400)
	@echo "test request with client cert - OK"
else
	@echo "test request with client cert - fail"
endif
