#!/usr/bin/env bash

docker run -d \
	-p 3000:3000 -p 3022:3022 \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v /tmp/harness:/data \
	--name opensource \
	--restart always \
	harness/harness