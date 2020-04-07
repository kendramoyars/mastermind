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
    attr_accessor :num_tries, :guess_input, :guess, :guess_display, :code, :feedback, :board, :gamemode, :code_input, :prev_guess
    
    def initialize
      @num_tries = ""
      @prev_guess = []
      @guess_input = ""
      @code_input = ""
      @gamemode = ""
      @code = 4.times.map{Random.rand(1..6)}
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
      choose_game_mode

    end

    def choose_game_mode
      puts "Do you want to be the codemaker or the codebreaker?"
      self.gamemode = gets.chomp.downcase
      if gamemode != "codebreaker" && gamemode != "codemaker"
        puts ""
        puts "Choose either codemaker or codebreaker."
        choose_game_mode
      else
        choose_num_tries
      end
    end

    def choose_num_tries
      puts "What number of guesses would you like to have?"
      self.num_tries = Integer(gets.chomp)
      puts ""
      if gamemode == "codebreaker"
        get_input
      else
        get_code
      end
      
    end

    def get_input
      puts "What 4 digit code would you like to try?"
      self.guess_input = gets.chomp.to_s
      verify_input
    end

    def input_error_message
      puts "Enter a 4 digit number, with each of the numbers being between 1-6."
      puts ""
      if gamemode == "codebreaker"
        get_input
      else
        get_code
      end
    end

    def get_code
      puts "Enter a 4 digit code with each number being between or including 1-6."
      self.code_input = gets.chomp.to_s
      verify_code
    end

    def verify_code
      @code = code_input.split(//)
      if code.length == 4
        code.each do |num|
          if !(num.to_i >= 1 && num.to_i <= 6)
            input_error_message
          end
        end
        computer_guess
      else
        input_error_message
      end
    end

    def verify_input
      @guess = guess_input.split(//)
      if guess.length == 4
        guess.each do |num|
          if !(num.to_i >= 1 && num.to_i <= 6 )
            input_error_message
          end
        end
        check_guess
      else
        input_error_message
      end
    end

    def computer_guess
      if prev_guess == []
        puts "running for the first time"
        self.guess = 4.times.map{Random.rand(1..6)}
        self.prev_guess = guess.map {|num| num}
        check_guess
      else

        puts "not running for the first time"
        print prev_guess
        puts ""
        puts guess
        prev_guess.each.with_index do |num, index|
          code.each do |x|
            if num.to_i == x.to_i && num.to_i == code[index].to_i
              guess[index] = num
              prev_guess[index] = nil
            end
          end
        end

        #remembers guess for one round but then forgets it? has to do with prev_guess var

        puts ""

        guess.map! do |num|
          if num == nil
            num = Random.rand(1..6)
          else
            num
          end
        end

        prev_guess = guess.map {|num| num}
        print prev_guess
        puts ""
        p guess
        check_guess


      end

    end

    def check_guess
      self.num_tries -= 1
      guess.map!{ |num| num.to_i }
      code.map!{ |num| num.to_i }
      guess.map.with_index { |num, i| guess_display[i] = num}
      
      guess.each.with_index do |num, index|
        code.each do |code_num|
          if num == code_num && num == code[index]
            feedback[index] =  "●"
            guess[index] = nil
          elsif num == code_num && num != code[index]
            feedback[index] = "○"
            guess[index] = nil
          else
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
      #check if computer or codebreaker
      if feedback == ["●", "●", "●", "●"]
        puts "You win!!"
        exit
      elsif num_tries == 0
        puts "This one's over for now. Try again next time."
        exit
      else
        feedback.map! {|num| num = " "}
        if gamemode == "codebreaker"
          get_input
        else
          computer_guess
        end
      end
    end

  end

  game = Game.new.play
end
