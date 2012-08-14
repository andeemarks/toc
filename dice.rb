
class Dice
  def initialize(station_id)
    @station_id = station_id
  end

  def roll
    roll = 1 + rand(6)
    # puts "Rolled #{dice} for station-#{@station_id}"

    return roll
  end
end

