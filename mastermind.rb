class Game

	@@peg_colours = ["RED", "BLUE", "YELLOW", "GREEN"]
	

	def create_code
		@code = []
		4.times do
			@code << @@peg_colours.sample
		end
		@colour_occurences = @code.each_with_object(Hash.new(0)) { |colour,counts| counts[colour] += 1 }
		# DELETE puts @colour_occurences
	end

	def show_code
		puts ""
		puts @code.to_s
	end

	def guess_code
		@guess = []
		puts
		puts "Make your guess (i.e. 'r' or 'red'):"
		4.times do |n|
			print "Peg #{n+1}: "
			guess_peg
		end
		# DELETE puts "Code is " + @code.to_s
		# DELETE puts "Guessed:" + @guess.to_s
	end

	def guess_peg
		@colour_guess = gets.chomp.downcase[0]
		unabbreviate
		@guess << @colour_guess
	end

	def unabbreviate
		case
		when @colour_guess == "r" then @colour_guess = "RED"
		when @colour_guess == "b" then @colour_guess = "BLUE"
		when @colour_guess == "y" then @colour_guess = "YELLOW"
		when @colour_guess == "g" then @colour_guess = "GREEN"
		else @colour_guess = "-"
		end
	end

	def check_for_victory
		if @guess == @code
			puts "You win!"
			@victory = true
		end
	end

# Go through each peg in the guess and see if it's colour matches that of any pegs in the code.
# If it does, see if it is also in the same position as any pegs of that colour. If it is, show
# a "O" pin. If it isn't but the colour is found in the code, show an "X" pin, but only if all
# pegs of that colour have not already been guessed. Fill remaining pin spaces with ".".
	
	def check_pegs
		colour_counter = @colour_occurences.clone # creates a new hash from colour_occurences
		colour_counter.merge!(colour_counter) do |key, old_value, new_value|
  			0 # sets all values of colour_counter to 0
		end
		pins = []
		pos = 0

		4.times do # check for full matches
			if @code.include?(@guess[pos]) && @code[pos] == @guess[pos]
				# DELETE puts "Full match: #{@guess[pos]}"
				pins << "O"
				colour_counter[@guess[pos]] += 1
			end
			pos += 1
		end

		pos = 0

		4.times do # check for colour matches
			# if code includes colour and all colour occurences have not been accounted for and the colour is not in the right position
			if @code.include?(@guess[pos]) && colour_counter[@guess[pos]] < @colour_occurences[@guess[pos]] && @code[pos] != @guess[pos]
				# DELETE puts "Colour match: #{@guess[pos]}"
				pins << "!"
				colour_counter[@guess[pos]] += 1
			end
			pos += 1
		end

		until pins.length == 4
			pins << "."
		end

		puts @guess.join(" ") + " | " + pins.join(" ")

	end

	def play
		create_code
		@turn = 0
		until @victory == true || @turn > 12
			# DELETE show_code
			puts
			puts "Turn #{@turn} of 12"
			guess_code
			check_for_victory
			check_pegs
			@turn += 1
			if @turn > 12
				puts
				puts "You lose!"
			end
		end
	end


end

game = Game.new
game.play