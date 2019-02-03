require_relative( 'models/customer' )
require_relative( 'models/screening' )
require_relative( 'models/film' )
require_relative( 'models/ticket' )

require( 'pry' )

Ticket.delete_all()
# Screening.delete_all()
Film.delete_all()
Customer.delete_all()



customer1 = Customer.new({ 'name' => 'Joe Bloggs', 'funds' => 200.00 })
customer1.save()
customer2 = Customer.new({ 'name' => 'Jenny Smith', 'funds' => 50.00 })
customer2.save()
customer3 = Customer.new({ 'name' => 'John Jones', 'funds' => 100.00 })
customer3.save()
customer4 = Customer.new({ 'name' => 'Brogan Rudge', 'funds' => 130.50 })
customer4.save()

# binding.pry
film1 = Film.new({ 'title' => 'Bohemian Rhapsody', 'price' => 7.00})
film1.save()
film2 = Film.new({ 'title' => 'The Green Book', 'price' => 6.50})
film2.save()
film3 = Film.new({ 'title' => 'A Star is Born', 'price' => 9.50})
film3.save()
film4 = Film.new({ 'title' => 'Bohemian Rhapsody', 'price' => 7.00})
film4.save()

screen1 = Screening.new({ 'start_time' => '12:30', 'max_capacity' => 20, 'film_id' => film1.id})
screen1.save()
screen2 = Screening.new({ 'start_time' => '15:00', 'max_capacity' => 40, 'film_id' => film1.id})
screen2.save()
screen3 = Screening.new({ 'start_time' => '18:00', 'max_capacity' => 20, 'film_id' => film1.id})
screen3.save()
screen4 = Screening.new({ 'start_time' => '21:00', 'max_capacity' => 40,'film_id' => film2.id})
screen4.save()
screen5 = Screening.new({ 'start_time' => '22:00', 'max_capacity' => 2, 'film_id' => film3.id})
screen5.save()
screen6 = Screening.new({ 'start_time' => '23:00', 'max_capacity' => 2, 'film_id' => film4.id})
screen6.save()



ticket1 = Ticket.new({ 'customer_id' => customer1.id, 'screening_id' => screen1.id})
ticket1.save()
# update after each ticket sale?
# customer_update = ticket1.sell_ticket()
# customer_update.update()

ticket2 = Ticket.new({ 'customer_id' => customer2.id, 'screening_id' => screen1.id})
ticket2.save()
ticket3 = Ticket.new({ 'customer_id' => customer3.id, 'screening_id' => screen1.id})
ticket3.save()
ticket4 = Ticket.new({ 'customer_id' => customer3.id, 'screening_id' => screen4.id})
ticket4.save()
ticket5 = Ticket.new({ 'customer_id' => customer4.id, 'screening_id' => screen2.id})
ticket5.save()
ticket6 = Ticket.new({ 'customer_id' => customer2.id, 'screening_id' => screen5.id})
ticket6.save()



Customer.all()

Film.all()
# get back first name in console: Customer.all()[0].name
Ticket.all()

customer4.name = 'Maddy Rudge'
customer4.update()
# customer4.delete() # checking ON DELETE CASCADE
film2.title = "The Favourite"
film2.update()
# film3.delete() # checking ON DELETE CASCADE
# ticket1.delete()
ticket6.customer_id = customer3.id
ticket6.update()
# ticket6.delete()

# customer2.films()
screen1.customers()
# film2.customers()

# Buying tickets should decrease the funds of the customer by the price
# customer1.buytickets()
# customer1.funds -= customer1.films().map{|film| film.price}.sum
# customer1.update()

# # Check how many tickets were bought by a customer
# # customer2.check_num_films()
# customer2.films().length
#
# # Check how many customers are going to watch a certain film
# film2.customers().length

binding.pry
nil
