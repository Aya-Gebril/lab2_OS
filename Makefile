
SHELL := /bin/bash

.PHONY: build run restore clean

build:
	mkdir -p malicious
	chmod +x antivirusd.sh restore.sh

run: build
	bash ./antivirusd.sh monitored malicious 5

restore: build
	bash ./restore.sh monitored malicious

clean:
	rm -f directory-info.last directory-info.new