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
  ]

  let(:agents_md) { Rails.root.join("AGENTS.md").read }

  it "has one for each of the 8 app folders" do
    found = Dir.glob(Rails.root.join("app/**/STANDARDS.md")).map do |path|
      Pathname(path).relative_path_from(Rails.root).dirname.to_s
    end

    expect(folders.size).to eq(8)
    expect(found).to match_array(folders)
  end

  folders.each do |folder|
    it "mentions #{folder}/STANDARDS.md in AGENTS.md" do
      expect(agents_md).to include("#{folder}/STANDARDS.md")
    end
  end
end
