require_relative 'production_line'

class ProductionLineSimulator
	def initialize(line)
		@line = line
	end

	def run
		puts @line.header
		puts @line
		while (!@line.is_finished?)
			@line.run_one_cycle

			puts @line
		end
	end

end

line = ProductionLine.new(:number_stations => 3, :inventory => 100)
ProductionLineSimulator.new(line).run
