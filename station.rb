require 'dice'

class Station
  attr_reader :station_id, :score
  attr_accessor :size

  def initialize(id)
    @station_id = id
    @size = 0
    @score = 0
    @dice = Dice.new(@station_id)
  end

  def get_inventory_adjustment
    return @dice.roll
  end

  def to_s
    return sprintf("    (Sc: %3d) ", @score) if (@size == 0)
    return sprintf("%3d (Sc: %3d) ", @size, @score)
  end

  def add_to_inventory(amount)
    @size = @size + amount
    @score = @score + (amount - 3.5)
  end

  def remove_from_inventory_upto(maximum)
    capacity = [maximum, @size].min
    @size = @size - capacity

    return capacity
  end

  def is_empty?
    return @size <= 0
  end


end

class PartsBin < Station
  def initialize(size)
    @size = size
  end

  def to_s
    return sprintf("Bin:     ") if @size <= 0
    return sprintf("Bin: %3d ", @size)
  end
end
