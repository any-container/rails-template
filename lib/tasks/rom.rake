namespace :rom do
  desc "Run ROM migrations in db/rom/migrate. VERSION=<n> migrates up or down to that version (0 reverts all)."
  task migrate: :environment do
    target = ENV["VERSION"]&.to_i
    RomContainer.migrate(target: target)
    puts "ROM migrations done#{" (version #{target})" if target}"
  end

  desc "Show whether ROM migrations are pending"
  task status: :environment do
    pending = RomContainer.pending?
    puts pending ? "pending" : "up to date"
  end
end
