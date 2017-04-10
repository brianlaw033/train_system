require('spec_helper')
require('pry')

describe(Station) do

  before() do
    @newStation = Station.new({:name => "Taikoo", :id => nil})
    @newStation2 = Station.new({:name => "Causeway Bay", :id => nil})
    @train = Train.new({:id => nil})
  end

  describe('.all') do
    it('starts off with no stations') do
      expect(Station.all()).to(eq([]))
    end
  end

  describe(".find") do
    it("returns a station by its ID number") do
      @newStation.save()
      @newStation2.save()
      expect(Station.find(@newStation2.id)).to(eq(@newStation2))
    end
  end

  describe("#==") do
    it("is the same station if it has the same name and id") do
      station2 = @newStation
      expect(@newStation).to(eq(station2))
    end
  end

  describe("#delete") do
    it("lets you delete a station from the database") do
      @newStation.save()
      @newStation2.save()
      @newStation.delete()
      expect(Station.all()).to(eq([@newStation2]))
    end
  end

  describe('#insert_tt') do
    it('adds a new timetable ') do
      @newStation.save()
      @train.save()
      train2 = @train
      train2.save()
      @newStation.insert_tt([@train.id, train2.id], ['10:03', '10:06'])
      expect(@newStation.trains()).to(eq([@train, train2]))
    end
  end

end
