# Rails Best Practices injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# Copy the per-folder CONTEXT.md files onto the app root. Thor prompts on conflicts.
directory ".", "."
