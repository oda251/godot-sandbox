# Addons

Vendored Godot addons under `addons/`.

| Addon | Version | Source |
|---|---|---|
| `gdUnit4` | v6.1.3 | https://github.com/MikeSchulze/gdUnit4 |

## How to update gdUnit4

```bash
TAG=v6.1.4   # target version
rm -rf addons/gdUnit4
git clone --depth 1 --branch "$TAG" https://github.com/MikeSchulze/gdUnit4 /tmp/gdUnit4-src
cp -R /tmp/gdUnit4-src/addons/gdUnit4 addons/
rm -rf addons/gdUnit4/test   # strip self-tests
```

Then update the version in this file and in `addons/gdUnit4/plugin.cfg` if needed.
