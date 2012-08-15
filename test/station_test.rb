require 'minitest/spec'
require 'minitest/autorun'
require 'station'

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

  describe "#add_to_inventory" do
    it "increases the size of the station by the amount added" do
      original_size = @station.size

      @station.add_to_inventory(3)

      @station.size.must_equal original_size + 3
    end

    it "will change the score of the station by the difference between the amount added and average" do
      original_score = @station.score

      @station.add_to_inventory(4)

      @station.score.must_equal original_score + (4 - Station::AVERAGE_INVENTORY_TO_ADD)
    end

  end

  describe "#remove_from_inventory" do
    it "will decrease the size by the amount removed" do
      original_size = @station.size

      amount_removed = @station.remove_from_inventory

      @station.size.must_equal original_size - amount_removed
    end

    it "will not remove anything if the station is empty" do
      @station.has_inventory?.must_equal false

      @station.remove_from_inventory.must_equal 0
    end
  end

  describe "#to_s" do
    it "will show both the size and score if the size is greater than 0" do
      @station.add_to_inventory(3)

      @station.to_s.must_equal "  3 (  0) "
    end

    it "will show just and score if the size is 0" do
      @station.has_inventory?.must_equal false

      @station.to_s.must_equal "    (  0) "
    end
  end
end
