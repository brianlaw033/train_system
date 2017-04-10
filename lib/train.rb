class Train

  attr_reader(:name, :id)

  def initialize(attributes)
    @id = attributes.fetch(:id)
  end

  def self.all()
    returned_trains = DB.exec('SELECT * FROM trains;')
    trains = []
    returned_trains.each do |train|
      id = Integer(train.fetch('id'))
      trains.push(Train.new({:id => id}))
    end
    trains
  end

  def self.find(id)
    Train.new({:id => id})
  end

  def save()
    result = DB.exec("INSERT INTO trains DEFAULT VALUES returning id")
    @id = Integer(result.first.fetch("id"))
  end


  def ==(another_train)
    self.id == another_train.id
  end

  def insert_tt(station_ids, arrival_times)
    length = station_ids.length - 1
    for i in 0..length
      DB.exec("INSERT INTO tt (train_id, station_id, arrival_time) VALUES (#{self.id}, #{station_ids[i]}, '#{arrival_times[i]}');")
    end
  end

  def stations()
    train_stations = []
    results = DB.exec("SELECT stations.*, tt.arrival_time FROM stations
    JOIN tt ON (stations.id = tt.station_id)
    JOIN trains ON (tt.train_id = trains.id)
    WHERE trains.id = #{self.id()};")
    results.each() do |result|
      station_id = Integer(result.fetch("id"))
      name = result.fetch('name')
      arrival_time = result.fetch('arrival_time')
      train_stations.push({:name => name, :id => station_id, :arrival_time => arrival_time})
    end
    train_stations
  end

  define_method(:delete) do
    DB.exec("DELETE FROM tt WHERE train_id = #{self.id()};")
    DB.exec("DELETE FROM trains WHERE id = #{self.id()};")
  end
end
