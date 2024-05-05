.PHONEY: openssl-build-image openssl-sh

DOCKER_OPENSSL_RUN=docker run --rm -it --name $(DOCKER_OPENSSL_CONTAINER_NAME) -v $(CA_PATH):/result $(DOCKER_OPENSSL_IMAGE)

openssl-build-image: ## pull openssl image
	docker build -t $(DOCKER_OPENSSL_IMAGE) .

openssl-sh: ## run openssl container
	docker run --entrypoint "" --rm -it --name $(DOCKER_OPENSSL_CONTAINER_NAME)_sh -v $(CA_PATH):/result $(DOCKER_OPENSSL_IMAGE) sh
