# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Invoice.scoped.destroy_all
1.upto(200) do |i|
  total_paid = 100 + Random.rand(100)
  total_charged = 100 + Random.rand(100)
  Invoice.create!(title: "Inoivce ##{i}", total_paid: total_paid, total_charged: total_charged,
                  paid: total_paid >= total_charged)
end