# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user = User.new(
  :email => "takeshi.mori@o-g.co.jp",
  :password => "yamahasrx400#4",
  :full_name => "Takeshi Mori",
)
user.skip_confirmation!
user.save
user.add_role "admin"
user.add_role "operator"
user.add_role "user"
user.add_role "customer"

user = User.new(
    :email => "zerowired.xb12s@gmail.com",
    :password => "yamahasrx400#4",
    :full_name => "Takeshi Mori",
)
user.skip_confirmation!
user.save
user.add_role "operator"
user.add_role "user"
user.add_role "customer"
