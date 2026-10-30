# Feature Registry

Tracks which features are built into the app and which are switched on in this deployment. Features are toggled per deployment through ENV variables; the static default for each lives in `features/0-manifest.yml`. Every other feature depends on this one and must be injected after it.

## Requirements
- Rails: 8.1
- Database: none
- Gems: none

## Injection
Run from the host app root:

    bin/rails app:template LOCATION=/path/to/features/feature_registry/template.rb

The template:
- Copies `features/feature_registry.md` (this feature's description) into the app's root `features/` folder.
- Creates `features/0-manifest.yml`. If the host already has one, it is kept and `FEATURE_FEATURE_REGISTRY: "true"` is appended once.
- Copies `config/features.rb` (the `Features` module) and `config/initializers/00_features.rb`.
- Copies `spec/feature_registry/features_spec.rb`.
- Makes no gem or route edits. Runs no migrations.

## Configuration
The app's `features/` folder holds:

| File | Contents |
|------|----------|
| `0-manifest.yml` | Flat map of `FEATURE_<NAME>` to `"true"` or `"false"`. The static representation of the feature ENV variables. |
| `<name>.md` | One description per feature. Front matter keys: `always_on` (default false), `depends_on` (feature names), `gems` (a name, or `name` and `version`). The body is free text. |

At boot the initializer copies each manifest entry into `ENV` unless the deployment already sets that variable, so real ENV overrides the manifest. It then validates:
- every description has a manifest entry, and every manifest entry has a description;
- every dependency exists, with no cycles;
- no enabled feature has a dependency switched off.

Any failure raises `Features::Invalid` and stops boot.

An `always_on` feature is enabled whatever its ENV value.

## Interface

    Features.enabled?(:name)   # toggled on, and every dependency enabled
    Features.toggled?(:name)   # this feature's own switch only
    Features.built?(:name)     # a description file exists
    Features.names             # every built feature
    Features.gems              # gems of every built feature, as hashes with "name" and optional "version"

## Adding a feature to the registry
Every feature ships `files/features/<name>.md` with its front matter and appends its entry to the manifest in `template.rb`:

    manifest = "features/0-manifest.yml"
    append_to_file manifest, %(FEATURE_<NAME>: "false"\n) unless File.read(manifest).include?("FEATURE_<NAME>:")

## Testing
`bundle exec rspec spec/feature_registry`
