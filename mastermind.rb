class Game

	@@peg_colours = ["RED", "BLUE", "YELLOW", "GREEN"]
	

	def create_code
		@code = []
		4.times do
			@code << @@peg_colours.sample
		end
		@colour_occurences = @code.each_with_object(Hash.new(0)) { |colour,counts| counts[colour] += 1 }
		puts @colour_occurences
	end

	def show_code
		puts ""
		puts @code.to_s
	end

	def guess_code
		@guess = []
		puts
		puts "Make your guess (i.e. 'rbyg'):"
		4.times do |n|
			print "Peg #{n+1}: "
			guess_peg
		end
		puts @guess.to_s
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

	def check_pegs
		colour_counter = @colour_occurences.clone

		colour_counter.merge!(colour_counter) do |key, old_value, new_value|
  			0
		end

		pins = []
		@guess.each do |guess|
			counter = 0
			if @code.include?(guess)
				if @code[counter] == @guess[counter] # correct colour and position
					unless colour_counter[guess] >= @colour_occurences[guess]
						pins << "O"
						colour_counter[guess] += 1
					end
				elsif @code.include? guess
					unless colour_counter[guess] >= @colour_occurences[guess]
						pins << "X" # correct colour but wrong position
						colour_counter[guess] += 1
					end
				end
			end
			counter += 1
		end
		until pins.length == 4
			pins << "."
		end

		puts "Occur: " + @colour_occurences.to_s
		puts "Count: " + colour_counter.to_s

		puts
		puts "#{pins[0]} #{pins[1]}"
		puts "#{pins[2]} #{pins[3]}" 
	end

	def play
		create_code
		until @victory == true
			show_code
			guess_code
			check_for_victory
			check_pegs
		end
	end


end

game = Game.new
game.create_code
game.show_code
game.guess_code
game.check_pegs