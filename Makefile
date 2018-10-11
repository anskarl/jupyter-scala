VER_TAG=anskarl/jupyter-scala:2.0.0
LATEST_TAG=anskarl/jupyter-scala:latest

image:
	@echo "Creating image with tags '$(VER_TAG)' and '$(LATEST_TAG)'"
	docker build -t $(VER_TAG) . && docker tag $(VER_TAG) $(LATEST_TAG)

push:
	@echo "Pushing image with tags '$(VER_TAG)' and '$(LATEST_TAG)'"
	docker push $(VER_TAG) && docker push $(LATEST_TAG)

clean:
	@echo "Deleting image with tags '$(VER_TAG)' and '$(LATEST_TAG)'"
	docker rmi $(VER_TAG) && docker rmi $(LATEST_TAG)