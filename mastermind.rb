module Mastermind

  class Board
    attr_accessor :guess, :feedback
    def initialize(guess, feedback)
      @guess = guess
      @feedback = feedback
    end

    def print_board
      br = "--------------"
      puts ""
      puts br
      puts "#{@guess[0].to_s} | #{@guess[1].to_s} | #{@guess[2].to_s} | #{@guess[3].to_s}"
      puts br
      puts "#{@feedback[0]} | #{@feedback[1]} | #{@feedback[2]} | #{@feedback[3]}"
      puts br
      puts ""
    end
  end

  class Game
    attr_accessor :num_tries, :guess_input, :guess, :guess_display, :code, :feedback, :board
    
    def initialize
      @num_tries = ""
      @guess_input = ""
      @code = 4.times.map{Random.rand(6)}
      @guess = ""
      @guess_display = [" ", " ", " ", " "]
      @feedback = [" ", " ", " ", " "]
      @board = Board.new(guess_display, feedback)
    end

 

    def play
      puts ""
      puts "Let's Play Mastermind!"
      puts "There are two players in this game, the Codebreaker and the Codemaker."
      puts "The Codemaker creates a combination of 4 numbers."
      puts "Each number is between 1-6."
      puts "It's the Codebreakers job to guess the combination in a given amount of tries."
      puts ""
      puts "Each time you guess, you will be provided feedback beneath your guess."
      puts "● = The correct number and position."
      puts "○ = The number is in the code but is in the wrong position."
      puts "  = Wrong number."
      puts ""
      puts ""
      puts "What number of guesses would you like to have?"
      self.num_tries = Integer(gets.chomp)
      puts ""
      get_input
    end

    def get_input
      puts "What 4 digit code would you like to try?"
      self.guess_input = gets.chomp.to_s
      verify_input
    end

    def input_error_message
      puts "Enter a 4 digit number, with each of the numbers being between 1-6."
      puts ""
      get_input
    end

    def verify_input
      @guess = guess_input.split(//)
      if guess.length == 4
        guess.each do |num|
          if num.to_i <= 1 && num.to_i >= 6 
            input_error_message
          end
        end
        check_guess
      else
        input_error_message
      end
    end

    def check_guess
      self.num_tries -= 1
      guess.map! { |num| num.to_i }
      guess.map.with_index { |num, i| guess_display[i] = num}
      
      guess.each_with_index do |num, index|
        code.each do |code_num|
          if num == code_num && num == code[index]
            feedback[index] =  "●"
            guess[index] = nil
          elsif num == code_num && num != code[index]
            feedback[index] = "○"
            guess[index] = nil
          end
        end
      end
      display_results
    end

    def display_results
      board.print_board
      puts ""
      puts "You still have #{num_tries} guesses left!"
      puts ""
      check_game_over
    end

    def check_game_over
      if feedback == ["●", "●", "●", "●"]
        puts "You win!!"
        exit
      elsif num_tries == 0
        puts "This one's over for now. Try again next time."
        exit
      else
        get_input
      end
    end

  end

  game = Game.new.play
end
