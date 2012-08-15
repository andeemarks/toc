require 'minitest/spec'
require 'minitest/autorun'
require 'production_line'

describe ProductionLine do
  before do
    @line = ProductionLine.new({:number_stations => 3, :inventory => 50})
  end

  describe "when constructed" do
    it "should take a number of stations as a parameter" do
      @line.stations.size.must_equal 3
    end

    it "should take a total inventory as a parameter" do
      @line.capacity.must_equal 50
    end

    it "should reject a negative inventory" do
      lambda{ProductionLine.new({:number_stations => 3, :inventory => -10})}.must_raise(ArgumentError)
    end

    it "should reject a negative number of stations" do
      lambda{ProductionLine.new({:number_stations => -3, :inventory => 50})}.must_raise(ArgumentError)
    end

    it "will create a PartsBin station with the initial inventory" do
      @line.bin.size.must_equal 50
    end

  end

  describe "#is_finished?" do
    it "should be true when the last station is at capacity" do
      @line.is_finished?.must_equal false
      @line.stations = Array.new(1, PartsBin.new(50))
      @line.is_finished?.must_equal true
    end
  end

  describe "#get_source_station_for_id" do
    it "will return the PartsBin if we're on the first station" do
      @line.get_source_station_for_id(0).must_equal @line.bin
    end
  end
end
