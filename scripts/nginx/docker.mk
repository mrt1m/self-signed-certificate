.PHONY: nginx-run

nginx-run: ## build and run nginx container
	docker build -t $(DOCKER_OPENSSL_CONTAINER_NAME)/nginx-alpine ./nginx
	docker ps -q --filter "name=$(DOCKER_OPENSSL_CONTAINER_NAME)_example" | xargs -r docker stop
	docker run -d --rm --name $(DOCKER_OPENSSL_CONTAINER_NAME)_example -p 443:443 $(DOCKER_OPENSSL_CONTAINER_NAME)/nginx-alpine

