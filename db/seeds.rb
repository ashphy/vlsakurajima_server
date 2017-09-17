# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

CSV.foreach('db/transition_seeds.csv') do |row|
  screen_name = if row[2] == 'null'
                  nil
                else
                  row[2]
                end
  Message.create(
    message: row[1],
    screen_name: screen_name,
    count: row[3].to_i,
    user_id: row[5]
  )
end
