class ProductionLineSimulator
	def run(line, total_inventory)
		@unprocessed_inventory = total_inventory
		@line = line
		puts @line
		while (@unprocessed_inventory > 0)
			@line.stations.each_with_index do |station, index|
				move_inventory_to_station(station, index)
			end

			puts "#{@unprocessed_inventory} items remaining"
			puts @line
		end
		puts @line.to_report
	end

	def move_inventory_to_station(station, index)
		dice = station.get_inventory_adjustment
		if index == 0 then
			inventory_to_move = [dice, @unprocessed_inventory].min
			station.add_to_inventory(inventory_to_move)
			@unprocessed_inventory = @unprocessed_inventory - inventory_to_move
		else
			inventory_to_move = @line.stations[index - 1].remove_from_inventory_upto(dice)
			station.add_to_inventory(inventory_to_move)

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
		s = 'Inventory: '
		@stations.each do |station|
			s << station.to_s
		end

		s
	end

	def to_report
		s = 'Report: '
		@stations.each do |station|
			s << station.report
		end

		s
	end

end

class Dice
	def initialize(station_id)
		@station_id = station_id
	end

	def roll
		dice = 1 + rand(6)
		puts "Rolled #{dice} for station-#{@station_id}"

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
		return sprintf("#{station_id}:__ ") if (@size == 0)

		return sprintf("#{station_id}:%-2d ", @size)
	end

	def report
		return sprintf("%d:%-2d ", @station_id, @score)
	end

	def add_to_inventory(amount)
		@size = @size + amount
		add_to_score(amount - 3.5)
	end

	def add_to_score(score)
		@score = @score + score
	end

	def remove_from_inventory_upto(maximum)
		capacity = [maximum, @size].min
		@size = @size - capacity

		return capacity
	end
end

line = ProductionLine.new(:stations => 4)
ProductionLineSimulator.new.run(line, 100)