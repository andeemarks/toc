class ProductionLineSimulator
	def initialize(line, total_inventory)
		@unprocessed_inventory = total_inventory
		@line = line
		puts @line
	end

	def run()
		while (!@line.is_finished?)
			@line.stations.each_with_index do |station, index|
				move_inventory_to_station(station, index)
			end

			puts @line
			# print " #{@unprocessed_inventory} items remaining"
		end
	end

	def move_inventory_to_station(station, index)
		dice = station.get_inventory_adjustment
		if (index == 0) then
			if (@unprocessed_inventory > 0) then
				inventory_to_move = [dice, @unprocessed_inventory].min
				station.add_to_inventory(inventory_to_move)
				@unprocessed_inventory = @unprocessed_inventory - inventory_to_move
			end
		else
			previous_station = @line.stations[index - 1]
			if (!previous_station.is_empty?) then
				inventory_to_move = previous_station.remove_from_inventory_upto(dice)
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
	end

	def to_s
		s = ''
		@stations.each do |station|
			s << station.to_s
		end

		s
	end

	def is_finished?
		@stations.last.size >= 100
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
	attr_reader :station_id, :size, :score

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
		return sprintf("    (%3d) ", @score) if (@size == 0)

		return sprintf("%3d (%3d) ", @size, @score)
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

line = ProductionLine.new(:stations => 4)
ProductionLineSimulator.new(line, 100).run
