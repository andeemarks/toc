
class Station
  attr_reader :score, :size

  AVERAGE_INVENTORY_TO_ADD = 3.5

  def initialize
    @size = @score = 0
  end

  def add_to_inventory(amount)
    @size = @size + amount
    @score = @score + (amount - AVERAGE_INVENTORY_TO_ADD)
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
    return 1 + rand(6)
  end

end

class PartsBin < Station
  def initialize(size)
    @size = size
  end

  def to_s
    return sprintf("   .") if @size <= 0
    return sprintf("%3d.", @size)
  end
end
