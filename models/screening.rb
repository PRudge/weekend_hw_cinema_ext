require_relative("../db/sql_runner")

class Screening

  attr_reader :id
  attr_accessor :start_time, :max_capacity, :film_id

  def initialize( details )
    @id = details['id'].to_i if details['id']
    @start_time = details['start_time']
    @max_capacity = details['max_capacity']
    @film_id = details['film_id']
  end

  # Get the customers for a specific screening
  def customers()
    sql = "SELECT customers.*
      FROM customers
      INNER JOIN tickets
      ON tickets.customer_id = customers.id
      WHERE tickets.screening_id = $1"
    values = [@id]
    customer_data = SqlRunner.run(sql, values)
    result = customer_data.map{|customer| Customer.new(customer)}
    return result
  end

  def tickets()
    sql = "SELECT tickets.*
    FROM tickets WHERE screening_id = $1"
    values = [@id]
    ticket_data = SqlRunner.run(sql, values)
    result = ticket_data.map{|ticket| Ticket.new(ticket)}
    return result
  end

  def save()
    sql = "INSERT INTO screenings
    ( start_time, max_capacity, film_id ) VALUES ( $1, $2, $3 ) RETURNING id"
    values = [@start_time, @max_capacity, @film_id]
    screening = SqlRunner.run( sql, values ).first
    @id = screening['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET ( start_time, max_capacity, film_id ) = ( $1, $2, $3 )
    WHERE id = $4"
    values = [@start_time, @max_capacity, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screenings WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM screenings"
    values = []
    screenings = SqlRunner.run(sql, values)
    return screenings.map{|screening| Screening.new(screening)}
  end

  def self.find(id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    SqlRunner.run(sql, values)
    screening = SqlRunner.run(sql, values).first
    return screening
  end

  def self.delete_all()
    sql = "DELETE FROM screenings"
    values = []
    SqlRunner.run(sql, values)
  end

end
