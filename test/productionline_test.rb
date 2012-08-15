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
  end

  describe "#is_finished?" do
    it "should be true when the last station is at capacity" do
      @line = ProductionLine.new({:number_stations => 3, :inventory => 50})

      @line.is_finished?.must_equal true
    end
  end
end
