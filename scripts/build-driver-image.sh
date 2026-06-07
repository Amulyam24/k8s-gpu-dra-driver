#!/usr/bin/env bash

# Copyright 2023 The Kubernetes Authors.
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

# Copyright (c) Advanced Micro Devices, Inc. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the \"License\");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an \"AS IS\" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -exuo pipefail

SCRIPT_DIR="$(cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd)"
source "${SCRIPT_DIR}/common.sh"

TMP_DIR="$(mktemp -d)"; trap 'rm -rf "${TMP_DIR}"' EXIT

cd "${PROJECT_DIR}"

make docker-generate

# Support multi-arch builds via MULTIARCH=true environment variable
if [[ "${MULTIARCH:-false}" == "true" ]]; then
    echo "Building multi-arch image for platforms: ${PLATFORMS}"
    make -f deployments/container/Makefile "${DRIVER_IMAGE_PLATFORM}-multiarch"
else
    echo "Building single-arch image for current platform"
    make -f deployments/container/Makefile "${DRIVER_IMAGE_PLATFORM}"
fi
