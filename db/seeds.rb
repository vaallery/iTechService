# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(username: 'admin', email: 'admin@itechstore.foo', role: 'admin', password: 'azaexe', password_confirmation: 'azaexe')

DeviceType.create [
  {name: "iPhone 4 16GB"},
  {name: "iPhone 4 32GB"},
  {name: "iPhone 5 64GB"},
  {name: "iMac 27"},
  {name: "MacBook Air"},
  {name: "MacBook Pro"}
]

Task.create [
  {
    name: "Update",
    priority: rand(10),
    cost: rand(5)*1000,
    duration: rand(20)*10
  },
  {
    name: "Install soft",
    priority: rand(10),
    cost: rand(5)*1000,
    duration: rand(20)*10
  },
  {
    name: "Repair",
    priority: 8,
    cost: rand(5)*1000,
    duration: rand(20)*10
  },
  {
    name: "Install media",
    priority: rand(10),
    cost: rand(5)*1000,
    duration: rand(20)*10
  },
  {
    name: "Jailbreak",
    priority: rand(10),
    cost: rand(5)*1000,
    duration: rand(20)*10
  },
  {
    name: "Unlock",
    priority: rand(10),
    cost: rand(5)*1000,
    duration: rand(20)*10
  }
]
