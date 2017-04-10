require("sinatra")
  require("sinatra/reloader")
  also_reload("lib/**/*.rb")
  require("./lib/train")
  require("./lib/station")
  require('pry')
  require("pg")

  DB = PG.connect({:dbname => "train_system"})

  get("/") do
    erb(:index)
  end

  get("/admin") do
    @trains = Train.all()
    @stations = Station.all()
    erb(:admin)
  end

  get('/admin/new_train') do
    erb(:new_train)
  end

  post('/admin/train') do
    train = Train.new({:id => nil})
    train.save()
    redirect to('/admin')
  end

  get('/admin/new_station') do
    erb(:new_station)
  end

  post('/admin/station') do
    name = params.fetch('name')
    station = Station.new({:id => nil, :name => name})
    station.save()
    redirect to('/admin')
  end

  get('/trains/:id') do
    @train = Train.find(Integer(params.fetch('id')))
    @stations = Station.all()
    erb(:train_info)
  end

  patch("/trains/:id") do
    train_id = Integer(params.fetch("id"))
    @train = Train.find(train_id)
    station_ids = params.fetch("station_ids")
    arrival_time = params.fetch("arrival_time")
    arrival_time.delete("")
    @train.insert_tt(station_ids, arrival_time)
    @stations = Station.all()
    redirect to("/trains/#{train_id}")
  end

  get('/stations/:id') do
    @station = Station.find(Integer(params.fetch('id')))
    @trains = Train.all()
    erb(:station_info)
  end

  get('/rider') do
    @trains = Train.all()
    @stations = Station.all()
    erb(:rider)
  end
