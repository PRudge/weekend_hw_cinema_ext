require_relative("../db/sql_runner")

class Customer

  attr_reader :id
  attr_accessor :name, :funds

  def initialize( details )
    @id = details['id'].to_i if details['id']
    @name = details['name']
    @funds = details['funds'].to_f
  end

  # get tickets for a specific customer
  def tickets()
    sql = "SELECT tickets.*
      FROM tickets WHERE tickets.customer_id = $1"
    values = [@id]
    tickets_data = SqlRunner.run(sql, values)
    result = tickets_data.map{|ticket| Ticket.new(ticket)}
    return result
  end

  # # Get the screenings for a specific customer
  def screenings()
    sql = "SELECT screenings.*
      FROM screenings
      INNER JOIN tickets
      ON tickets.screening_id = screenings.id
      WHERE tickets.customer_id = $1"
    values = [@id]
    screening_data = SqlRunner.run(sql, values)
    result = screening_data.map{|screening| Screening.new(screening)}
    return result
  end

  def buy_ticket(price)
    if sufficient_funds?(price)
      @funds -= price
    end
  end

  def sufficient_funds?(item)
    return funds >= item
  end

  def save()
    sql = "INSERT INTO customers
    ( name, funds ) VALUES ( $1, $2 ) RETURNING id"
    values = [@name, @funds]
    customer = SqlRunner.run( sql, values ).first
    @id = customer['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET ( name, funds ) = ( $1, $2 ) WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    return customers.map{|customer| Customer.new(customer)}
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end
end
