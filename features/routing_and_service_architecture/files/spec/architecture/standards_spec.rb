require "rails_helper"

RSpec.describe "STANDARDS.md files" do
  folders = %w[
    app/controllers
    app/controllers/concerns
    app/jobs
    app/models
    app/relations
    app/repos
    app/services
    app/views
    spec
  ]

  let(:agents_md) { Rails.root.join("AGENTS.md").read }

  it "has one for each of the 9 folders" do
    found = (Dir.glob(Rails.root.join("app/**/STANDARDS.md")) + Dir.glob(Rails.root.join("spec/STANDARDS.md"))).map do |path|
      Pathname(path).relative_path_from(Rails.root).dirname.to_s
    end

    expect(folders.size).to eq(9)
    expect(found).to match_array(folders)
  end

  folders.each do |folder|
    it "mentions #{folder}/STANDARDS.md in AGENTS.md" do
      expect(agents_md).to include("#{folder}/STANDARDS.md")
    end
  end

  describe "hash syntax" do
    # A symbol key written with a hash rocket, e.g. `:name => value`.
    symbol_rocket = /(?<![:\w]):[A-Za-z_]\w*[?!]?\s*=>/

    it "uses no hash rockets for symbol keys in app/ and spec/" do
      offenders = Dir.glob(Rails.root.join("{app,spec}/**/*.rb")).flat_map do |path|
        File.readlines(path).each_with_index.filter_map do |line, index|
          next if line.lstrip.start_with?("#")

          "#{Pathname(path).relative_path_from(Rails.root)}:#{index + 1}" if line.match?(symbol_rocket)
        end
      end

      expect(offenders).to be_empty
    end
  end
end
