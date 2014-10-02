IMAGE=hissohathair/openpds
DOCKER=docker
PORTMAP=8002:8002

help:
	@echo " "
	@echo "Make targets for $(IMAGE):"
	@echo "    build	Build docker build and tag"
	@echo "    push 	Push build to Docker repository"
	@echo "    run  	Start the application"
	@echo "    clean 	Delete the image"
	@echo " "

build: Dockerfile
	$(DOCKER) build -t $(BUILD) .

run: build
	$(DOCKER) run -p $(PORTMAP) $(BUILD)

push: build
	$(DOCKER) push $(BUILD)

clean:
	$(DOCKER) rmi -f $(BUILD)
