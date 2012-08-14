require 'dice'

class Station
  attr_reader :station_id, :score, :size

  def initialize(id)
    @station_id = id
    @size = @score = 0
    @dice = Dice.new(@station_id)
  end

  def get_amount_to_move
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

  def remove_from_inventory
    preferred_amount = get_amount_to_move
    allowed_amount = [preferred_amount, @size].min
    @size = @size - allowed_amount

    return allowed_amount
  end

  def has_inventory?
    return @size > 0
  end


end

class PartsBin < Station
  def initialize(size)
    @size = size
    @dice = Dice.new(0)
  end

  def to_s
    return sprintf("Bin:    .") if @size <= 0
    return sprintf("Bin: %3d.", @size)
  end
end
