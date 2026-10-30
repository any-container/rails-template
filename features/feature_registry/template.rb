# Feature Registry injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# 1. Copy features/ (manifest and description), config/features.rb, the boot initializer, and the spec.
#    Thor prompts on conflicts. An existing features/0-manifest.yml is the host's deployment config:
#    keep it and add the missing entry below.
directory ".", ".", exclude_pattern: %r{/features/0-manifest\.yml\z}

# 2. Create the manifest if absent, otherwise append the feature_registry entry once.
manifest = "features/0-manifest.yml"
entry = %(FEATURE_FEATURE_REGISTRY: "true"\n)
if File.exist?(manifest)
  append_to_file manifest, entry unless File.read(manifest).include?("FEATURE_FEATURE_REGISTRY:")
else
  copy_file manifest, manifest
end
