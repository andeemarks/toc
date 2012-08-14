class ProductionLineSimulator
	def initialize(line)
		@line = line
	end

	def run()
		puts @line
		while (!@line.is_finished?)
			simulate_one_cycle

			puts @line
		end
	end

	def simulate_one_cycle
		@line.stations.each_with_index do |station, index|
			move_inventory_to_station(station, index)
		end
	end

	def move_inventory_to_station(station, index)
		dice = station.get_inventory_adjustment
		source = @line.get_source_station_for_id(index)
		if (index == 0) then
			if (@line.remaining_inventory > 0) then
				inventory_to_move = [dice, @line.remaining_inventory].min
				station.add_to_inventory(inventory_to_move)
				@line.remaining_inventory = @line.remaining_inventory - inventory_to_move
			end
		else
			if (!source.is_empty?) then
				inventory_to_move = source.remove_from_inventory_upto(dice)
				station.add_to_inventory(inventory_to_move)
			end
		end
	end

end

class ProductionLine
	attr_reader :stations

	def initialize(options)
		@stations = Array.new(options[:stations]) {|index|
			Station.new(index + 1)
		}
		@bin = PartsBin.new(options[:inventory])
	end

	def get_source_station_for_id(station_id)
		return @bin if station_id == 0

		return @stations[station_id - 1]
	end

	def to_s
		s = @bin.to_s
		@stations.each do |station|
			s << station.to_s
		end

		s
	end

	def is_finished?
		@stations.last.size >= 100
	end

	def remaining_inventory
		@bin.size
	end

	def remaining_inventory=(new_value)
		@bin.size = new_value
	end
end

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

line = ProductionLine.new(:stations => 4, :inventory => 100)
ProductionLineSimulator.new(line).run
