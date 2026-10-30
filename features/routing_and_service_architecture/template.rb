# Routing and Service Architecture injection. See FEATURE.md.
source_paths.unshift(File.expand_path("files", __dir__))

# Agent-tool files that point at AGENTS.md. Relative link target, keyed by path.
AGENT_FILE_LINKS = {
  "CLAUDE.md" => "AGENTS.md",
  "GEMINI.md" => "AGENTS.md",
  "CONVENTIONS.md" => "AGENTS.md",
  ".cursorrules" => "AGENTS.md",
  ".windsurfrules" => "AGENTS.md",
  ".clinerules" => "AGENTS.md",
  ".rules" => "AGENTS.md",
  ".github/copilot-instructions.md" => "../AGENTS.md"
}.freeze

# 1. Copy AGENTS.md and the per-folder STANDARDS.md files. Thor prompts on conflicts.
#    Symlinks in files/ are recreated below, not copied as regular files.
directory ".", ".", exclude_pattern: Regexp.union(AGENT_FILE_LINKS.keys.map { |path| %r{/#{Regexp.escape(path)}\z} })

# 2. Link the other agent-tool files to AGENTS.md. Existing files are left alone.
AGENT_FILE_LINKS.each do |path, target|
  next if File.exist?(path) || File.symlink?(path)

  empty_directory File.dirname(path) unless File.dirname(path) == "."
  create_link path, target
end

# 3. Enforce symbolized hash keys (see AGENTS.md). Skipped when .rubocop.yml already configures the cop.
HASH_SYNTAX_COP = <<~YAML

  # Use `key: value`, not `:key => value`. See AGENTS.md.
  Style/HashSyntax:
    Enabled: true
YAML

if File.exist?(".rubocop.yml")
  append_to_file ".rubocop.yml", HASH_SYNTAX_COP unless File.read(".rubocop.yml").include?("Style/HashSyntax")
else
  create_file ".rubocop.yml", HASH_SYNTAX_COP.lstrip
end
