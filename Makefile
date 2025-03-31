VERSION ?= latest
REVISION := $(shell git rev-parse --short HEAD)
UNAME_OS := $(shell uname -s)
ARCH_OS := $(shell uname -m)
ifneq ($(UNAME_OS),Darwin)
	ifeq ($(ARCH_OS),x86_64)
		STATIC_LINK_FLAG := -linkmode external -extldflags "-static"
	else
		STATIC_LINK_FLAG := -linkmode auto
	endif
endif

emulator/build:
	CGO_ENABLED=1 CXX=clang++ go build -o bigquery-emulator \
		-ldflags='-s -w -X main.version=${VERSION} -X main.revision=${REVISION} ${STATIC_LINK_FLAG}' \
		./cmd/bigquery-emulator

docker/build:
	docker build -t bigquery-emulator . --build-arg VERSION=${VERSION}
