Factory.define(:user) do |f|
  f.first_name { fake(:name, :first_name) }
  f.last_name { fake(:name, :last_name) }
  f.sequence(:email) { |n| "user#{n}@example.com" }
  f.timestamps
end
