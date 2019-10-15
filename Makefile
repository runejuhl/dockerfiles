# Build all Docker images, tag them. Automatically fetches all upstream docker
# images if Dockerfiles have changed. Hopefully.

SHELL=/bin/bash
# Use nprocs/2 up to a max of 4 processes
MAKEFLAGS+="-j -l $(shell $(( n=$(nproc) / 2 , n <= 4 ? n : 4 )))"

export DOCKER_USER = $(USER)
FIND_CMD := "find . -maxdepth 2 -wholename '*/Dockerfile*' -not -name '*~' | sed -r 's@^\./@@g'"
ALL := $(shell eval $(FIND_CMD))
# Find all Dockerfiles, grep for parent images, modify to prefix with ".docker"
# and remove the ":" from image name (because Make doesn't like it)
DOCKER_IMAGES := $(shell echo $(ALL) | xargs grep -hoE '^FROM +[^ ]+' | sed -r 's/FROM +([^ ]+).*/\1/g' | sort | uniq | sed -r 's@:@.@g' | sed -rE 's@^@.docker/@g')

.PHONY: all
all: $(ALL)

# Uses ONESHELL to be able to set a variable
.ONESHELL:
$(DOCKER_IMAGES):
	image=$(shell echo $(patsubst .docker/%,%,$(@)) | sed -r 's#^([^.]+)\.(.+)$$#\1:\2#')
	docker pull $$image && mkdir -p $(shell dirname $(@)) && docker inspect $$image > $(@)

.PHONY: $(ALL)
.ONESHELL:
$(ALL): $(DOCKER_IMAGES)
	set -euo pipefail
	name=$(shell dirname $(@))
	export metadata_file=$$name/metadata.sh
	if test -f $$metadata_file; then
		set -a
		. $$metadata_file
		set +a
	fi
	image_name=$(DOCKER_USER)/$$name
	docker build -t $$image_name -f $(@) $(shell cat $(shell dirname $(@))/metadata.sh | sed -r 's/^/--build-arg /g') $$name
