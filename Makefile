#!/usr/bin/make --no-print-directory --jobs=1 --environment-overrides -f

# Copyright (c) 2023  The Go-Curses Authors
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#: uncomment to echo instead of execute
#CMD=echo

-include .env
#export

.PHONY: install-symlinks install-shortlinks install-caselinks

BIN_NAME := strcaseto
UNTAGGED_VERSION := v0.1.0
UNTAGGED_COMMIT := 0000000000

SHELL := /bin/bash
LOG_LEVEL := debug

GO_ENJIN_PKG := nil
BE_LOCAL_PATH := nil

GOPKG_KEYS ?= CDK CTK CLD CLE CLN CLP

CDK_GO_PACKAGE ?= github.com/go-curses/cdk
CDK_LOCAL_PATH ?= ../cdk

CTK_GO_PACKAGE ?= github.com/go-curses/ctk
CTK_LOCAL_PATH ?= ../ctk

CLD_GO_PACKAGE ?= github.com/go-curses/corelibs/diff
CLD_LOCAL_PATH ?= ../corelibs/diff

CLE_GO_PACKAGE ?= github.com/go-curses/corelibs/errors
CLE_LOCAL_PATH ?= ../corelibs/errors

CLN_GO_PACKAGE ?= github.com/go-curses/corelibs/notify
CLN_LOCAL_PATH ?= ../corelibs/notify

CLP_GO_PACKAGE ?= github.com/go-curses/corelibs/path
CLP_LOCAL_PATH ?= ../corelibs/path


CLEAN_FILES     ?= ${BIN_NAME} ${BIN_NAME}.*.* coverage.out pprof.*
DISTCLEAN_FILES ?=
REALCLEAN_FILES ?=

BUILD_VERSION_VAR := main.BuildVersion
BUILD_RELEASE_VAR := main.BuildRelease

SYMLINKS_PREFIX ?= to-
SYMLINKS_SUFFIX ?= -case

SRC_CMD_PATH := ./cmd/strcaseto

define help_custom_targets
	@echo "  install-symlinks   - install to-{strcase}-case symlinks"
	@echo "  install-shortlinks - install to-{strcase} symlinks"
	@echo "  install-caselinks  - install {strcase} symlinks"
endef

include Golang.cmd.mk
include Golang.def.mk

install-symlinks:
	@echo "# installing ${BIN_NAME} symlinks"
	@if [ -f "${INSTALL_BIN_PATH}/${BIN_NAME}" ]; then \
		pushd "${INSTALL_BIN_PATH}" > /dev/null; \
		for name in camel kebab lower-camel screaming-kebab screaming-snake snake; do \
			ln -svf "${BIN_NAME}" "${SYMLINKS_PREFIX}$${name}${SYMLINKS_SUFFIX}"; \
		done; \
		popd > /dev/null; \
	else \
		echo "error: ${INSTALL_BIN_PATH}/${BIN_NAME} not found" 1>&2; \
		false; \
	fi

install-shortlinks: SYMLINKS_PREFIX=to-
install-shortlinks: SYMLINKS_SUFFIX=
install-shortlinks: install-symlinks

install-caselinks: SYMLINKS_PREFIX=
install-caselinks: SYMLINKS_SUFFIX=
install-caselinks: install-symlinks

#: begin debian packaging branch changes
-include Debian.mk
export
#: end debian packaging branch changes
