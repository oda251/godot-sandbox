# godot-sandbox

Godot 4 sandbox for experiments and learning.

## Tooling

Tools are managed via [mise](https://mise.jdx.dev/) (configured in chezmoi at `dot_config/mise/config.toml.tmpl`):

| Tool | Backend | Purpose |
|---|---|---|
| `godot` | `aqua:godotengine/godot` | Game engine |
| `gdtoolkit` (`gdlint`, `gdformat`) | `pipx:gdtoolkit` | GDScript lint / format |

## Quick start

```bash
# Open the editor
godot

# Run the project headlessly (CI-style check)
godot --headless --quit

# Lint / format (project files only; vendored addons excluded)
find . -name "*.gd" -not -path "./addons/*" -print0 | xargs -0 gdlint
find . -name "*.gd" -not -path "./addons/*" -print0 | xargs -0 gdformat --check

# Run gdUnit4 tests
godot --headless -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --ignoreHeadlessMode -a test/
```

## Pre-commit hooks

[lefthook](https://github.com/evilmartians/lefthook) runs `gdlint` and `gdformat --check` on staged `.gd` files. Install hooks once per clone:

```bash
lefthook install
```

## Addons

Vendored under `addons/`. See [`ADDONS.md`](./ADDONS.md) for versions and update procedure.

## Type safety

Project-level GDScript warnings are set to **error** in `project.godot`:

- `untyped_declaration` — variables/parameters must declare a type
- `unsafe_call_argument`, `unsafe_cast`, `unsafe_method_access`, `unsafe_property_access`, `unsafe_void_return` — no implicit dynamic access

`inferred_declaration` (`var x := 1`) is set to warn rather than error — `:=` is allowed but flagged for review.
