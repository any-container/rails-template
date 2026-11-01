Factory.define(:account) do |f|
  f.sequence(:name) { |n| "Account #{n}" }
  f.association(:owner)
  f.timestamps
end
