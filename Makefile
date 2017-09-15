IMAGE ?= kaigara/kitebox
TAG   ?= $(shell git describe --tags --abbrev=0 2>/dev/null || echo "1.0.0")

.PHONY: build

build:
	echo "Building $(IMAGE):$(TAG)"
	docker build -t "$(IMAGE):$(TAG)" .
start: build
	docker run -d --name="kitebox" $(IMAGE):$(TAG)
clean:
	docker rm $(docker stop {kitebox})
