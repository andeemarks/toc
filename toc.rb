class ProductionLineSimulator
	def run
		total_inventory = inventory_remaining = 100

		line = ProductionLine.new(:stations => 4)
		print line
		while (inventory_remaining > 0)
			line.stations.each_with_index do |station, index|
				dice = station.get_inventory_adjustment
				if index == 0 then
					inventory_to_move = [dice, inventory_remaining].min
					station.add_to_inventory(inventory_to_move)
					inventory_remaining = inventory_remaining - inventory_to_move
				else
					inventory_to_move = line.stations[index - 1].remove_from_inventory_upto(dice)
					station.add_to_inventory(inventory_to_move)

				end
				# print line
			end

			print line
		end
		puts line.report
	end
end

class ProductionLine
	attr_reader :stations

	def initialize(options)
		puts "Creating ProductionLine with #{options[:stations]} stations"
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

	def report
		s = "\nReport: "
		@stations.each do |station|
			s << station.report
		end

		s
	end

	def size
		@stations.size
	end
end

class Dice
	def initialize(station_id)
		@station_id = station_id
	end

	def roll
		dice = 1 + rand(6)
		puts "\nThrew #{dice} for station-#{@station_id + 1}"

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
		return "#{station_id}: _ " if (@size == 0)

		return "#{station_id}: #{size} "
	end

	def report
		return "#{station_id}: #{score} "
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

ProductionLineSimulator.new.run