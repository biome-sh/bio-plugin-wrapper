# shellcheck shell=bash

# Bio Plugin Wrapper
# Wraps a package
#
# Variables:
# `pkg_wrapper_for` - original package ident to wrap
#
# Functions:
# `do_wrapper_build_config` - Wraps package configuration

do_default_build_config() {
    do_wrapper_build_config
}

do_wrapper_build_config() {
    if [[ -z "${pkg_wrapper_for:-}" ]]; then
        exit_with "You loaded wrapper plugin but did not specify pkg_wrapper_for." 1
    fi

    local wrapper_path

    wrapper_path="$(pkg_path_for "$pkg_wrapper_for")"

    build_line "Copying stock hooks and configs from $pkg_wrapper_for"

    if [[ -d "$wrapper_path/config" ]]; then
        # shellcheck disable=SC2154
        cp -r "$wrapper_path/config" "$pkg_prefix"
    fi

    if [[ -d "$PLAN_CONTEXT/config" ]]; then
        cp -r "$PLAN_CONTEXT/config" "$pkg_prefix"
    fi

    if [[ -d "$wrapper_path/config_install" ]]; then
        cp -r "$wrapper_path/config_install" "$pkg_prefix"
    fi

    if [[ -d "$PLAN_CONTEXT/config_install" ]]; then
        cp -r "$PLAN_CONTEXT/config_install" "$pkg_prefix"
    fi

    if [[ -d "$wrapper_path/hooks" ]]; then
        cp -r "$wrapper_path/hooks" "$pkg_prefix"
    fi

    if [[ -z "${pkg_svc_run:-}" ]] && [[ -f "$wrapper_path/run" ]]; then
        cp "$wrapper_path/run" "$pkg_prefix"
    fi

    if [[ -d "$PLAN_CONTEXT/hooks" ]]; then
        cp -r "$PLAN_CONTEXT/hooks" "$pkg_prefix"
    fi

    if [[ -f "$pkg_prefix/hooks/health_check" ]]; then
        warn "Renaming deprecated health_check to health-check"
        mv "$pkg_prefix/hooks/health_check" "$pkg_prefix/hooks/health-check"
    fi

    if [[ -f "$wrapper_path/default.toml" ]]; then
        cp "$wrapper_path/default.toml" "$pkg_prefix"
    fi

    if [[ -f "$PLAN_CONTEXT/default.toml" ]]; then
        cp "$PLAN_CONTEXT/default.toml" "$pkg_prefix"
    fi

    # shellcheck disable=SC2154
    if [[ ${#pkg_binds[@]} -eq 0 ]] && [[ -f "$wrapper_path/BINDS" ]]; then
        cp "$wrapper_path/BINDS" "$pkg_prefix"
    fi

    # shellcheck disable=SC2154
    if [[ ${#pkg_exports[@]} -eq 0 ]] && [[ -f "$wrapper_path/EXPORTS" ]]; then
        cp "$wrapper_path/EXPORTS" "$pkg_prefix"
    fi

    # shellcheck disable=SC2154
    if [[ ${#pkg_exposes[@]} -eq 0 ]] && [[ -f "$wrapper_path/EXPOSES" ]]; then
        cp "$wrapper_path/EXPOSES" "$pkg_prefix"
    fi
}
