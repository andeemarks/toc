require 'minitest/spec'
require 'minitest/autorun'
require '../lib/station'

describe Station do
  before do
    @station = Station.new
  end

  describe "when constructed" do
    it "should have a default size and score" do
      @station.size.must_equal 0
      @station.score.must_equal 0
    end
  end

  describe "#has_inventory?" do
    it "should return true if station size > 0" do
      @station.has_inventory?.must_equal false

      @station.add_to_inventory(3)
      @station.size.must_be :>, 0

      @station.has_inventory?.must_equal true
    end
  end
end
