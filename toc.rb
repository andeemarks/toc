require 'station'

class ProductionLineSimulator
	def initialize(line)
		@line = line
	end

	def run()
		puts @line
		while (!@line.is_finished?)
			@line.run_one_cycle

			puts @line
		end
	end

end

class ProductionLine
	attr_reader :stations

	def initialize(options)
		@stations = Array.new(options[:stations]) {|index|
			Station.new(index + 1)
		}
		@capacity = options[:inventory]
		@bin = PartsBin.new(@capacity)
	end

	def run_one_cycle
		@stations.each_with_index do |station, index|
			move_inventory_to_station(station, index)
		end
	end

	def is_finished?
		@stations.last.size >= @capacity
	end

	private

	def move_inventory_to_station(destination, index)
		source = get_source_station_for_id(index)
		if (source.has_inventory?) then
			inventory_to_move = source.remove_from_inventory
			destination.add_to_inventory(inventory_to_move)
		end
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
end


line = ProductionLine.new(:stations => 4, :inventory => 100)
ProductionLineSimulator.new(line).run
