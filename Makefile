XGOARCH := amd64
XGOOS := linux
XBIN := $(XGOOS)_$(XGOARCH)/journal

all: lint test install

test:
	go test ./...

vet:
	go vet ./...

fmt:
	bash -c "diff --line-format='%L' <(echo -n) <(gofmt -d -s .)"

lint: fmt vet

install:
	go install ./...

xinstall:
	env GOOS=$(XGOOS) GOARCH=$(XGOARCH) CGO_ENABLED=1 \
CC=x86_64-linux-musl-gcc go install -ldflags '-extldflags "-static"' ./...

publish:
ifndef DEST_PATH
	$(error DEST_PATH must be set when publishing)
endif
	rsync -a $(GOPATH)/bin/$(XBIN) $(DEST_PATH)/$(XBIN)
	@sha256sum $(GOPATH)/bin/$(XBIN)
