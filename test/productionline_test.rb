require 'minitest/spec'
require 'minitest/autorun'
require_relative '../lib/production_line'

describe ProductionLine do
  before do
    # @line = ProductionLine.new
  end

  describe "when constructed" do
    it "should take a number of stations as a parameter" do
      @line = ProductionLine.new({:number_stations => 3, :inventory => 50})

      @line.stations.size.must_equal 3
    end

    it "should take a total inventory as a parameter" do
      @line = ProductionLine.new({:number_stations => 3, :inventory => 50})

      @line.capacity.must_equal 50
    end

    it "should reject a negative inventory" do
      lambda{ProductionLine.new({:number_stations => 3, :inventory => -10})}.must_raise(ArgumentError)
    end

    it "should reject a negative number of stations" do
      lambda{ProductionLine.new({:number_stations => -3, :inventory => 50})}.must_raise(ArgumentError)
    end
  end

  describe "#is_finished?" do
    it "should be true when the last station is at capacity" do
      @line = ProductionLine.new({:number_stations => 3, :inventory => 50})

      @line.is_finished?.must_equal true
    end
  end
end
