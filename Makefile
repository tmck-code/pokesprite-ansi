DOCKER_REPO ?= ghcr.io/tmck-code/pokesay-convert
DOCKER_TAG ?= latest

DOCKER_IMAGE=$(DOCKER_REPO):$(DOCKER_TAG)

ifeq ($(shell which gecho > /dev/null 2>&1 && echo 1 || echo 0), 1)
	echo := gecho
else
	echo := echo
endif

ansi:
	@$(echo) -e "\e[48;5;30m> Converting all images to ANSI\e[0m"
	@docker run --rm \
		--platform linux/amd64 \
		-v $(PWD):/tmp/original/pokesprite \
		-v $(PWD):/tmp/ansi \
		-e DEBUG=$(DEBUG) \
		-u u \
		$(DOCKER_IMAGE) \
		bash -c "mkdir -p /tmp/convert/ \
			&& go run /usr/local/src/src/bin/convert/png_convert.go \
				-from    /tmp/original/pokesprite/ \
				-tmpDir  /tmp/convert/ \
				-to      /tmp/ansi/ \
				-padding 4"
	@find . -name '*.png' -type f -delete

.PHONY: ansi
