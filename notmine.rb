# A game that can be played by two human players or against a computer on the command line.
# The board is a 4 X 12 Grid. In a two player game players alternate turns until one
# player is victorious.

#One player becomes the codemaker, the other the codebreaker. The codemaker chooses a 
#pattern of four code pegs. Duplicates are allowed, so the player could even choose four 
#code pegs of the same color.

#The codebreaker tries to guess the pattern, in both order and color, within twelve turns. 
#Each guess is made by placing a row of code pegs on the decoding board. Once placed, the 
#codemaker provides feedback by placing from zero to four key pegs in the small holes of 
#the row with the guess. A colored or black key peg is placed for each code peg from the 
#guess which is correct in both color and position. A white key peg indicates the existence 
#of a correct color code peg placed in the wrong position.

#The codemaker gets one point for each guess a codebreaker makes. An extra point is earned by 
#the codemaker if the codebreaker doesn't guess the pattern exactly in the last guess. 
#(An alternative is to score based on the number of colored key pegs placed.) The winner is 
#the one who has the most points after the agreed-upon number of games are played.

module Mastermind
	# the player class will need to state whether the current player is the codebreaker or
	# codemaster. Will use status for this purpose
	class Player
		attr_reader :name, :wins
		attr_accessor :status
		def initialize(name, status, points = 0)
			@name = name
			@points = points
			@status = status
		end
	end

	class Board
		attr_accessor :board
		attr_reader :code
		@@pegs = {:R => "Red", :Y => "Yellow", :B => "Blue", :G => "Green", :O => "Orange", :P => "Pink"}
		def initialize(code)
			@board = []
			@code = code
		end

		def display_board
			@board.each do |row|
				print row.to_s + "\n"
			end
		end

		def self.pegs
			@@pegs
		end
	end

	class Game
		attr_accessor :game_board, :number_of_guesses
		attr_reader :code_array, :player1
		def initialize
			@number_of_guesses = 0
			get_player_information
			start_game
		end

		def start_game
			set_code
			create_board
			game_loop
			game_feedback
		end

		def get_player_information
			puts "Please enter your name:"
			player_name = gets.chomp.capitalize
			create_player(player_name)
		end

		def create_player(name)
			@player1 = Mastermind::Player.new(name, :codebreaker)
		end

		def set_code
			@code_array = []
			4.times {@code_array << Mastermind::Board.pegs.keys.sample}
		end

		def create_board
			@game_board = Mastermind::Board.new(@code_array)
		end

		def game_loop
			@game_won = false
			@game_not_won = false
			while !@game_won && !@game_not_won
				return_array = []
				intro
				@game_board.display_board
				code_guess = get_code_guess
				check_guess_against_code(code_guess) ? @game_won = true : return_array << guess_feedback(code_guess)
				@game_board.board << (code_guess + return_array)
				@number_of_guesses += 1
				@game_not_won = true if @number_of_guesses == 12
				system "clear" or system "cls"
			end
		end

		def intro
			puts "The peg colour options are: "
			Mastermind::Board.pegs.each do |key, val|
				puts "#{key.to_s}: #{val}"
			end
			puts "Please enter four colours using the corresponding letter."
			puts "Example. To enter Red, Red, Yellow, Green as an option you should enter RRYG and then press enter"
		end

		def get_code_guess
			puts "#{@player1.name} Please enter your code guess"
			code_guess = gets.chomp.upcase
			while !check_guess_valid?(code_guess) || !check_guess_unique?(code_guess)
					puts "Your input was incorrect or you've already guessed this code. Please try again"
					code_guess = gets.chomp.upcase
					check_guess_valid?(code_guess)
					check_guess_unique?(code_guess)
			end
			code_guess.split("").map{|val| val.to_sym}
		end

		def check_guess_valid?(code)
			return false if code.length != 4
			code.split("").each do |val|
				return false unless Mastermind::Board.pegs.keys.to_s.include?(val)
			end
			return true
		end

		def check_guess_unique?(code)
			return true if @game_board.board.empty?
			@game_board.board.each do |val|
				return false if val == code
			end
			return true
		end

		def check_guess_against_code(code)
			return true if code == @game_board.code
			return false
		end

		def guess_feedback(code)
			return_array = []
			guess_array = code.dup
			code_array = @game_board.code.dup
			guess_array.each_with_index do |val, index|
				if guess_array[index] == code_array[index]
					return_array << :BP
					guess_array.delete_at(index)
					code_array.delete_at(index)
				end
			end
			white_pieces = guess_array.find_all {|val| code_array.include?(val)}
			white_pieces.length.times do
				return_array << :WP
			end
			return_array
		end

		def game_feedback
			if @game_won
				puts "Congratulations #{@player1.name}. You won"
			else
				puts "Sorry #{@player1.name}. You didn't guess the code"
			end
		end
	end
end

Mastermind::Game.new