---
always_on: true
depends_on: []
gems: []
---
# Feature Registry

Tracks which features are built into this app and which are switched on in this deployment.

- `features/<name>.md` describes one feature. The front matter lists `always_on`, `depends_on` (feature names), and `gems` (name and optional version).
- `features/0-manifest.yml` maps each feature to its ENV variable, `FEATURE_<NAME>`.
- `config/features.rb` defines `Features`.
- `config/initializers/00_features.rb` loads the manifest into ENV and validates it at boot.

## Interface

    Features.enabled?(:name)   # toggled on, and every dependency enabled
    Features.built?(:name)     # a description file exists
    Features.names             # every built feature
    Features.gems              # gems of every built feature

An `always_on` feature is enabled whatever its ENV value. Boot fails if a feature is enabled while a dependency is off, a dependency is unknown or cyclic, or the manifest and the description files disagree.
