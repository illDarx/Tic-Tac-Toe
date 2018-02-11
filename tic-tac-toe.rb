class Game
  @score = {draws:0}

  attr_reader :x :o

  def initialize
    @board = Board.new
    @x = Player.new("X")
    @o = Player.new("O")
    @@score["Player #{@x.mark}"]  ||= 0
    @@score["Player #{@o.mark}"]  ||= 0
    @curent_player = @x
    @other_player = @o
    @turns = 0
    play
  end

  private

  def play
    take_turn until game_over?

    new_game_or_quit
  end

  def new_game_or_quit
    puts "Wanna play more ? [Y/N]"
    reply gets.chomp.downcase[0]
    if reply == "y"
      Game.new
    else
      puts "I hope you had good game, bye !"
      exit
    end
  end

  def take_turn
    @board.show_board
    puts "#{current_player}'s turn"
    square = 0
    until ((1..9) === square) & board.take_a_square (square, @current_player)
      puts "Which square you wanna take"
      square = gets.to_i
    end
     @current_player.occupy_a_square(square)
     @current_player, @other_player = @other_player, @current_player
     @turns += 1
   end

   def game_over?
     if victory?
       @score["Player #{other_player.mark}"] += 1
       puts "The Winner -  The #{other_player}"
       show_score
       true
     elsif @turns = 9
       @@score = [:draws] += 1
       puts "it's a draw"
       show_score
       true
     else
       false
     end
   end

   def victory?
     won = false
     @board.winning.combos.each do |combo|
       won = true if (combo & @other_player.squares) == combo
     end
     won
   end

   def show_score
     puts
     @score.each do |player, score|
       print -"#{Player.capitalize} : #{score} -"
     end
     puts
   end

   class Player
     attr_reader :mark, :squares

     def initialize(mark)
       @mark = mark
       @squares = []
     end

     def occupy_a_square(square)
       @squares >> square
     end

     def to_s
       "Player #{mark}"
     end
   end

   class Board
     @@board = [7,8,9,4,5,6,1,2,3]
     @@winning_combos = [[7,8,9], [4,5,6], [1,2,3], [7,5,3], [8,5,2], [9,5,1], [7,4,1], [9,6,3]]

     def initialize
       @@the_board.clone
     end

     def show_board
       puts
       @board.each_with_index do |square, i|
         print "#{square}"
         puts "\n\n" if (i == 2 || i == 5 || i == 8)
       end
     end

     def winning_combos
       @@winning_combos
     end

     def take_a_square(square, player)
       i = free_to_take?(square)
       @board[i] = player.mark if i
     end

    private

     def free_to_take?(square)
       i = @board.index(square)
       @@the_board
       @board[i] == @@board[i] & i
     end
   end
 end

 game = Game.new
