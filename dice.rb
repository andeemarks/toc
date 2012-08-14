
class Dice
  def initialize(station_id)
    @station_id = station_id
  end

  def roll
    dice = 1 + rand(6)
    # puts "Rolled #{dice} for station-#{@station_id}"

    return dice
  end
end

