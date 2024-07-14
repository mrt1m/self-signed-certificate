.PHONEY: step-create_all_certs-and-nginx_configs step-run_nginx step-run_tests

include .env
include scripts/*/*.mk

step-create_all_certs-and-nginx_configs:
	make init-ca CA_NAME=root.ca OPENSSL_CONFIG_NAME=openssl.root.ca.cnf OPENSSL_SERVER_EXT_NAME=server.ext.cnf
	make create-root-ca-cert CA_NAME=root.ca

	make init-ca CA_NAME=intermediate.level_1.root.ca OPENSSL_CONFIG_NAME=openssl.root.ca.cnf OPENSSL_SERVER_EXT_NAME=server.ext.cnf
	make create-intermediate-ca CA_NAME=intermediate.level_1.root.ca ROOT_CA_NAME=root.ca

	make init-ca CA_NAME=intermediate.level_2.root.ca OPENSSL_CONFIG_NAME=openssl.root.ca.cnf OPENSSL_SERVER_EXT_NAME=server.ext.cnf
	make create-intermediate-ca CA_NAME=intermediate.level_2.root.ca ROOT_CA_NAME=intermediate.level_1.root.ca

	make create-crl CA_NAME=root.ca
	make create-crl CA_NAME=intermediate.level_1.root.ca
	make create-crl CA_NAME=intermediate.level_2.root.ca

	make create-client-cert CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_1@lol.kek
	make export-client-cert CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_1@lol.kek

	make create-client-cert CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_2@lol.kek
	make export-client-cert CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_2@lol.kek

	make revoke-client-cert CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_1@lol.kek

	make create-crl CA_NAME=intermediate.level_2.root.ca

	make create-server-cert CA_NAME=intermediate.level_2.root.ca SERVER_HOST=localhost

	make nginx-init-certs CA_NAME=intermediate.level_2.root.ca SERVER_HOST=localhost

step-run_nginx:
	make nginx-run

step-run_tests:
	make test-https CA_NAME=intermediate.level_2.root.ca URL=https://localhost
	make test-client_verify CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_2@lol.kek URL=https://localhost/protection-magic/
	make test-revoke_client_cert CA_NAME=intermediate.level_2.root.ca CLIENT_EMAIL=user_1@lol.kek URL=https://localhost/protection-magic/

