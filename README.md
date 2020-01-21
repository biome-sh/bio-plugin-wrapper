# Biome Plugin Wrapper

This plugin helps you to wrap a package. Anything defined in this package will override original package.
It overrides `do_default_build_config`

Make sure you specify original package in `pkg_deps` or `pkg_build_deps`.
It is possible to borrow configuration from one package, but use binaries from another at build time or run time, or even build binaries by yourself.

## Usage

```
# We use binaries from core/nginx
pkg_deps+=(core/nginx)
pkg_build_deps+=(biome/bio-plugin-wrapper)

# Use configs, hooks, binds, exports, exposes from upstream package
pkg_wrapper_for=core/nginx

do_setup_environment() {
  source "$(pkg_path_for biome/bio-plugin-wrapper)/lib/plugin.sh"
}
```

Consider source [bio-plugin-wrapper](habitat/lib/plugin.sh)
