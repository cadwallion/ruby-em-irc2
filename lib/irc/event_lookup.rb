require 'yaml'

module IRC
	class EventLookup
		LOOKUP = YAML.load_file("#{File.dirname(__FILE__)}/eventmap.yml")

		def self.find_by_number(num)
			LOOKUP[num]
		end
	end
end
