class Station

  attr_reader(:name, :id)

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def self.all()
    returned_stations = DB.exec('SELECT * FROM stations;')
    stations = []
    returned_stations.each do |station|
      name = station.fetch('name')
      id = Integer(station.fetch('id'))
      stations.push(Station.new({:name => name, :id => id}))
    end
    stations
  end

  def self.find(id)
    result = DB.exec("SELECT * FROM stations WHERE id = #{id};")
    name = result.first.fetch('name')
    Station.new({:name => name, :id => id})
  end

  def save()
    result = DB.exec("INSERT INTO stations (name) VALUES ('#{@name}') RETURNING id;")
    @id = Integer(result.first.fetch("id"))
  end

  def ==(another_station)
    self.name == another_station.name && self.id == another_station.id
  end

  def update_station(attributes)
    @name = attributes.fetch(:name, @name)
    DB.exec("UPDATE stations SET name = '#{@name}' WHERE id = #{self.id()};")
  end

  def insert_tt(train_ids, arrival_times)
    length = train_ids.length - 1
    for i in 0..length
      DB.exec("INSERT INTO tt (train_id, station_id, arrival_time) VALUES (#{train_ids[i]}, #{self.id}, '#{arrival_times[i]}');")
    end
  end

  def trains()
    station_trains = []
    results = DB.exec("SELECT trains.*, tt.arrival_time FROM stations
    JOIN tt ON (stations.id = tt.station_id)
    JOIN trains ON (tt.train_id = trains.id)
    WHERE stations.id = #{self.id()};")
    results.each() do |result|
      arrival_time = result.fetch('arrival_time')
      train_id = result.fetch("id").to_i()
      station_trains.push({:id => train_id, :arrival_time => arrival_time})
    end
    station_trains
  end

  define_method(:delete) do
    DB.exec("DELETE FROM tt WHERE station_id = #{self.id()};")
    DB.exec("DELETE FROM stations WHERE id = #{self.id()};")
  end
end
