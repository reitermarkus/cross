#!/usr/bin/env bash

set -x
set -euo pipefail

main() {
    local dependencies=(
        ca-certificates
        curl
    )

    apt-get update
    local purge_list=()
    for dep in ${dependencies[@]}; do
        if ! dpkg -L $dep; then
            apt-get install --no-install-recommends -y $dep
            purge_list+=( $dep )
        fi
    done

    export RUSTUP_HOME=/tmp/rustup
    export CARGO_HOME=/tmp/cargo

    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o rustup-init.sh
    sh rustup-init.sh -y --no-modify-path
    rm rustup-init.sh

    PATH="${CARGO_HOME}/bin:${PATH}" cargo install cargo-xbuild --root /usr

    rm -r "${RUSTUP_HOME}" "${CARGO_HOME}"

    for dep in ${purge_list[@]}; do
      apt-get purge --auto-remove -y "${dep}"
    done

    rm $0
}

main "${@}"
