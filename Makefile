TAG = rvannauker/pdepend
VERSION = 1.0.0
FILE_NAME = pdepend.dockerfile
DESTINATION = .
DEBUG_COMMAND = /bin/bash
MICROBADGE_HOOK_URL = https://hooks.microbadger.com/images/rvannauker/pdepend/vGr17qRDYO9_P1X3Va6eqdUTIJI=

default: build

build:
	docker build \
	       --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
	       --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
	       --build-arg VERSION="$(VERSION)" \
	       --force-rm \
	       --tag "$(TAG):$(VERSION)" \
	       --file $(FILE_NAME) \
	       $$PWD

build_latest:
	docker build \
	       --build-arg BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ") \
	       --build-arg VCS_REF="$(git rev-parse --short HEAD)" \
	       --build-arg VERSION="latest" \
	       --force-rm \
	       --tag "$(TAG):latest" \
	       --file $(FILE_NAME) \
	       $$PWD

push:
	docker push $(TAG)

debug:
	docker run \
	       --rm \
	       --interactive \
	       "$(TAG)$(VERSION)" $(DEBUG_COMMAND)

run:
	@docker run \
	       --rm \
           --volume $$PWD:/workspace \
           --name "pdepend" \
           "$(TAG):$(VERSION)" \
           $(DESTINATION)

stats:
	docker run \
               --rm \
               --volume $$PWD:/workspace:rw \
               --name "pdepend" \
               "rvannauker/pdepend:1.0.0" \
               --dependency-xml=pdepend_dependencies.xml \
               --summary-xml=pdepend_summary.xml \
               --jdepend-chart=pdepend_jdepend.svg \
               --jdepend-xml=pdepend_jdepend.xml \
               --overview-pyramid=pdepend_pyramid.svg \
               .
microbadge_hook:
	curl -X POST $(MICROBADGE_HOOK_URL)

release: build build_latest push microbadge_hook
