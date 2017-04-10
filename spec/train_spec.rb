require('spec_helper')

describe(Train) do

  before() do
    @newStation = Station.new({:name => "Taikoo", :id => nil})
    @newStation2 = Station.new({:name => "Causeway Bay", :id => nil})
    @train = Train.new({:id => nil})
    @train2 = Train.new({:id => nil})
  end

  describe('.all') do
    it('starts off with no trains') do
      expect(Station.all()).to(eq([]))
    end
  end

  describe(".find") do
    it("returns a train by its ID number") do
      @train.save()
      @train2.save()
      expect(Train.find(@train2.id)).to(eq(@train2))
    end
  end

  describe("#==") do
    it("is the same train if it has the same name and id") do
      expect(@train).to(eq(@train2))
    end
  end

  describe('#save') do
     it('saves a train to the DB') do
       @train.save()
       expect(Train.all()).to(eq([@train]))
     end
   end

   describe('#insert_tt') do
     it('adds a new timetable ') do
       @newStation.save()
       @newStation2.save()
       @train.save()
       @train.insert_tt([@newStation.id, @newStation2.id], ['10:03', '10:06'])
       expect(@train.stations()).to(eq([@newStation, @newStation2]))
     end
   end
end
