class ProductionLineSimulator
	def run
		total_inventory = inventory_remaining = 100

		line = ProductionLine.new(:stations => 4)
		print line
		while (inventory_remaining > 0)
			dice = Dice.roll_for_station(1)
			if (inventory_remaining >= dice)
				line.stations[0].add_to_inventory(dice)
				inventory_remaining = inventory_remaining - dice
			end

			print line
			for station in 1..line.size - 1
				dice = Dice.roll_for_station(station + 1)
				inventory_to_move = line.stations[station - 1].remove_from_inventory_upto(dice)
				line.stations[station].add_to_inventory(inventory_to_move)

				print line
			end
		end
		puts line.report
	end
end

class ProductionLine
	attr_reader :stations
	def initialize(options)
		@number_of_stations = options[:stations]
		@stations = Array.new
		for station in 1..@number_of_stations
			@stations << Station.new(station)
		end
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
		@number_of_stations
	end
end

class Dice
	def self.roll_for_station(station_id)
		dice = 1 + rand(6)
		puts "Threw #{dice} for station-#{station_id}"

		return dice
	end
end

class Station 
	attr_reader :station_id, :size, :score

	def initialize(id)
		@station_id = id
		@size = 0
		@score = 0
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