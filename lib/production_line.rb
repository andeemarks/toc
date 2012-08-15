require_relative 'station'


class ProductionLine
	attr_reader :stations, :capacity, :bin
	attr_writer :stations

	def initialize(options)
		capacity = options[:inventory]
		raise ArgumentError if capacity.to_i <= 0

		number_stations = options[:number_stations]
		raise ArgumentError if number_stations.to_i <= 0

		@stations = Array.new(options[:number_stations]) {|index|
			Station.new
		}
		@capacity = capacity
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

	def header
		"Bin " + (Station.header * @stations.size)
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
		@stations.inject(@bin.to_s) {|start, station| start << station.to_s}
	end
end

