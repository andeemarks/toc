require 'dice'

class Station
  attr_reader :score, :size

  def initialize(id)
    @size = @score = 0
    @dice = Dice.new
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

  def to_s
    return sprintf("    (%3d) ", @score) if (@size == 0)
    return sprintf("%3d (%3d) ", @size, @score)
  end

  def self.header
    "Stn Score "
  end

  private

  def get_amount_to_move
    return @dice.roll
  end

end

class PartsBin < Station
  def initialize(size)
    @size = size
    @dice = Dice.new
  end

  def to_s
    return sprintf("   .") if @size <= 0
    return sprintf("%3d.", @size)
  end
end
