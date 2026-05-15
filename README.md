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

# Lint / format
gdlint .
gdformat --check .
```

## Type safety

Project-level GDScript warnings are set to **error** in `project.godot`:

- `untyped_declaration` — variables/parameters must declare a type
- `unsafe_call_argument`, `unsafe_cast`, `unsafe_method_access`, `unsafe_property_access`, `unsafe_void_return` — no implicit dynamic access

`inferred_declaration` (`var x := 1`) is set to warn rather than error — `:=` is allowed but flagged for review.
