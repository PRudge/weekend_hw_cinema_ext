require_relative("../db/sql_runner")

class Ticket

  attr_reader :id
  attr_accessor :customer_id, :screening_id

  def initialize( details )
    @id = details['id'].to_i if details['id']
    @customer_id = details['customer_id'].to_i
    @screening_id = details['screening_id'].to_i
  end

  # take cash after each ticket sale
  def sell_ticket()
    customer_dets = self.customer()
    screening_dets = self.screening()
    film_dets = self.film(screening_dets.film_id)
    film_price = film_dets.price
    customer_dets.buy_ticket(film_price)
    return customer_dets
  end

  # retrieve customer details for the ticket
  def customer()
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [@customer_id]
    customer = SqlRunner.run(sql, values).first
    return Customer.new(customer)
  end

  # retrieve screening details for the ticket
  def screening()
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [@screening_id]
    screening = SqlRunner.run(sql, values).first
    return Screening.new(screening)
  end

  # retrieve film details for the screening
  def film(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    film = SqlRunner.run(sql, values).first
    return Film.new(film)
  end

  def save()
    sql = "INSERT INTO tickets
    ( customer_id, screening_id ) VALUES ( $1, $2 ) RETURNING id"
    values = [@customer_id, @screening_id]
    ticket = SqlRunner.run( sql, values ).first
    @id = ticket['id'].to_i
  end

  def update()
    sql = "UPDATE tickets SET ( customer_id, screening_id ) = ( $1, $2 ) WHERE id = $3"
    values = [@customer_id, @screening_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    values = []
    tickets = SqlRunner.run(sql, values)
    return tickets.map{|ticket| Ticket.new(ticket)}
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    values = []
    SqlRunner.run(sql, values)
  end

  def self.most_tickets_sold()
    tickets_hash = self.all()
    tickets = tickets_hash.map{|ticket| ticket.screening_id}

    freq = tickets.inject(Hash.new(0)) { |screening,total| screening[total] += 1; screening }

    max_id = tickets.max_by { |screening| freq[screening] }
    total = freq[max_id]
    screening_info = Screening.find(max_id)
    most_tickets_sold = Hash.new

    most_tickets_sold[:time] = screening_info['start_time']
    most_tickets_sold[:total] = total
    return most_tickets_sold
  end

end
