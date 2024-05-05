.PHONEY: import-macos-ca

import-macos-ca: ## CA_NAME=intermediate.root.ca - import CA cert for macos
	sudo security add-trusted-cert \
				  -k /Library/Keychains/System.keychain \
				  -d -r trustAsRoot \
				  $(CA_PATH)/$(CA_NAME)/certs/ca.cert.pem

import-macos-client: ## CA_NAME=intermediate.root.ca CLIENT_EMAIL=user@lol.kek EXPORT_CLIENT_PASS=123123 - import client cert for macos
	sudo security import $(CA_PATH)/$(CA_NAME)/certs/$(CLIENT_EMAIL).pfx \
				  -k /Library/Keychains/System.keychain \
				  -A \
				  -P \$(EXPORT_CLIENT_PASS)
