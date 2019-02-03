require_relative("../db/sql_runner")

class Film

  attr_reader :id
  attr_accessor :title, :price, :film_array

  def initialize( details )
    @id = details['id'].to_i if details['id']
    @title = details['title']
    @price = details['price'].to_f
    @film_array = Array.new
  end

  # get all the screenings for a certain film
  def screenings()
    sql = "SELECT * FROM screenings WHERE film_id = $1"
    values = [@id]
    screenings_data = SqlRunner.run(sql, values)
    return screenings_data.map{|screening| Screening.new(screening)}
  end

  def how_many_customers()
    screenings_data = self.screenings()
    arr = screenings_data.map{|x| x.id}

    total = 0
    film_total = Hash.new
    @film_array = []

    arr.each do |scr_id|

      sql = "SELECT screenings.*
      FROM screenings
      INNER JOIN tickets
      ON tickets.screening_id = screenings.id
      WHERE tickets.screening_id = $1"

      values = [scr_id]
      screening_data = SqlRunner.run(sql, values)
      result = screening_data.map{|screening| Screening.new(screening)}
      film_total = Hash.new
      film_total[:film_time] = result[0].start_time
      film_total[:ft_total] = result.length

      @film_array << film_total
      total += result.length
    end
    # create a new hash with film name, film time details and the
    # overall total number of
    film_details = Hash.new
    film_details[:name] = @title
    film_details[:film_times] = film_array
    film_details[:total] = total
    return film_details

  end

  def most_pop_time()
    film_dets_hash = self.how_many_customers()
    result =  @film_array.max_by{|film_det| film_det['ft_total']}
    return result
  end

  def save()
    sql = "INSERT INTO films
    ( title, price ) VALUES ( $1, $2 ) RETURNING id"
    values = [@title, @price]
    film = SqlRunner.run( sql, values ).first
    @id = film['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2 ) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM films ORDER BY title"
    values = []
    films = SqlRunner.run(sql, values)
    return films.map{|film| Film.new(film)}
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end
end
