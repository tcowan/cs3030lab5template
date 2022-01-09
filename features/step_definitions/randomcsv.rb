#require_relative "peopledata"

class RandomCSV

	def initialize(csv, size=:small)
		@csv = csv
		@csvFilePath = File.join("tmp", "aruba", @csv)
		@peopleFilePath = File.join("tmp", "aruba", @csv + ".people")
		@classesFilePath = File.join("tmp", "aruba", @csv + ".classes")
		@firstNames = FIRSTNAMES
		@surNames = SURNAMES
		@cities = CITIES
		@states = STATES
		@zips = ZIPS
		@majors = MAJORS
		@courses = COURSES
		@termCodes = TERMCODES

		r = Random.new
		# determine number of people and classes
		if size == :small
			@peopleCount = r.rand(3..7)
			@classCount = r.rand(2..5)
		else
			@peopleCount = r.rand(2..100)
			@classCount = r.rand(5..20)
		end

		wnumber = 1
		@csvs = Array.new
		@people = Array.new
		@classes = Array.new
		for i in 1..@peopleCount
			if size == :small
				@classCount = r.rand(2..3)
			else
				@classCount = r.rand(5..20)
			end
			
			w = sprintf("W%07d", wnumber)
			f = @firstNames[r.rand(0..@firstNames.length-1)]
			s = @surNames[r.rand(0..@surNames.length-1)]
			m = @majors[r.rand(0..@majors.length-1)]
			c = @cities[r.rand(0..@cities.length-1)]
			st = @states[r.rand(0..@states.length-1)]
			z = @zips[r.rand(0..@zips.length-10)]
			p = %Q^#{w}|#{f}|#{s}|#{f}.#{s}@mail.weber.edu|#{m}|#{c}|#{st}|#{z}\n^
			@people << p

			for j in 1..rand(1..@classCount)
				course = @courses[r.rand(0..@courses.length-1)]
				termcode = @termCodes[r.rand(0..@termCodes.length-1)]
				csv = %Q^"#{w}","#{f}","#{s}","#{f}.#{s}@mail.weber.edu","#{m}","#{course}","#{termcode}","#{c}","#{st}","#{z}"^
				@csvs << csv
				subjCode, courseNumber = course.split(" ")
				cls = %Q^#{w}|#{subjCode}|#{courseNumber}|#{termcode}\n^
				@classes << cls
			end
			wnumber += 1
		end
		# create the csv file
		csvFile = File.open(@csvFilePath, "w")
		csvFile.write(%Q^wnumber,firstname,lastname,email,major,course,termcode,city,state,zip\n^)
		csvs.each do |c|
			csvFile.write(c+"\n")
		end
		csvFile.close		
		# create the classes output file
		classesFile = File.open(@classesFilePath, "w")
		@classes.each do |c|
			classesFile.write(c)
		end
		classesFile.close

		# create the people output file
		peopleFile = File.open(@peopleFilePath, "w")
		@people.each do |s|
			peopleFile.write(s)
		end
		peopleFile.close

	end

	def csvs
		return @csvs
	end
	def people
		return @people;
	end
	def classes
		return @classes
	end
	def peopleCount
		return @people.length
	end
	def classCount
		return @classes.length
	end
	def peopleFilePath
		return @peopleFilePath
	end
	def classesFilepath
		return @classesFilePath
	end
	
end
