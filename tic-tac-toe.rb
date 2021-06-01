class Player
  attr_reader :name, :symbol

  @@num_of_players = 0

  def initialize(name)
    @name = name
    if @@num_of_players == 0
      @symbol = 'o'
      @@num_of_players = 1
    else
      @symbol = '+'
    end
  end
end

class Board
  attr_accessor :board

  def initialize
    @board = Array.new(9)
  end

  def update_board(player, position)
    @board[position.to_i] = player.symbol
  end

  def display_board
    i = 0
    until i > 8
      pp @board[i..i + 2]
      i += 3
    end
  end
end

class Game
  attr_accessor :current_player

  @@win = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]

  def initialize
    @keep_going = true
    record_player
    @current_player = @p1
    @board = Board.new
    @board.display_board
    update_position while @keep_going
  end

  def record_player
    puts 'Welcome ! What is your name player1 ?'
    player1 = gets.chomp
    @p1 = Player.new(player1)
    puts "Thanks #{@p1.name}, and how about player 2 ?"
    player2 = gets.chomp
    @p2 = Player.new(player2)
    puts "#{@p2.name} you're in.
    \nLet's start this !
    \nHere is your board.
    \nIt's empty for now.\n"
  end

  def ask_position
    loop do
      puts "#{@current_player.name} Choose your case"
      @position = gets.chomp
      break if @board.board[@position.to_i].nil?
    end
  end

  def update_position
    if @board.board.any? { |e| e.nil? }
      check_win
      ask_position
      @board.update_board(@current_player, @position)
      @board.display_board
      switch_player
    else
      @keep_going = false
      puts "it's a tie"
      replay
    end
  end

  def check_win
    @@win.each do |arr|
      if @board.board[arr[0]] == @board.board[arr[1]] && @board.board[arr[2]] == @board.board[arr[0]] && !@board.board[arr[0]].nil?
        @keep_going = false
        switch_player
        puts "the winner is #{current_player.name} with the symbol #{current_player.symbol}"
        replay
      else
        @keep_going = true
      end
    end
  end

  def switch_player
    @current_player = if @current_player == @p1
                        @p2
                      else
                        @p1
                      end
  end

  def replay 
    puts "Would you like to replay ? type Y for yes and anything for no"
    @answer = gets.chomp
    if @answer == 'y' or @answer == 'Y'
      Game.new
    else
      exit
    end
  end
end

Game.new
