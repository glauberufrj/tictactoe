class Game
  def initialize
    @board = ["0", "1", "2", "3", "4", "5", "6", "7", "8"]
    @com = "X" # the computer's marker
    @hum = "O" # the user's marker
  end

  def start_game
    # Primeiro print do board
    board_print
    # Loop até o jogo ser ganho ou empatado
    until game_is_over(@board) || tie(@board)
      puts "Enter the position:"
      if !get_human_spot
        get_human_spot
      end
      #Jogada do humano
      board_print
      puts "-------------------------------------------------"
      if !game_is_over(@board) && !tie(@board)
        eval_board
        #Jogada do computador
        board_print
        puts "-------------------------------------------------"
      end
    end
    endgame
  end

  def board_print
    puts " #{@board[0]} | #{@board[1]} | #{@board[2]} \n===+===+===\n #{@board[3]} | #{@board[4]} | #{@board[5]} \n===+===+===\n #{@board[6]} | #{@board[7]} | #{@board[8]} \n"
  end

  def endgame
    puts "Do you want to play again?\n(Use \"y\" for yes or \"n\" for no)"
    @answer = gets.chomp()
    if @answer=="y"
      initialize
      start_game
      sleep(1)
    elsif @answer=="n"
      puts "Thanks for playing, bye"
      sleep(1)
    else
      puts "Invalid input, try again"
      sleep(1)
      endgame
    end
  end

  def get_human_spot
    spot = nil
    until spot
      spot = gets.chomp
      #Caso selecionado um valor não numérico
      if spot.match(/[^0-9]/)
        puts "The input must be a number between 0 and 8"
        return false
      else
        #Somente transformar para Integer caso o valor de fato seja um número, caso contrário a conversão retorna 0 e gera um bug
        spot = spot.to_i
      end
      unless spot.between?(0,8)
        puts "Invalid input, please select a number between 0 and 8"
        return false
      end
      if @board[spot] == "X" || @board[spot] == "O"
        puts "Invalid input, please select a number that hasn't been selected"
        return false
      else
        @board[spot] = @hum
        puts "PLAYER MOVE: => #{spot}"
        return true
      end
    end
  end

  def eval_board
    spot = nil
    until spot
      #A primeira marcação do computador é sempre no meio
      if @board[4] == "4"
        spot = 4
        @board[spot] = @com
      else
        spot = get_best_move(@board)
        #Checa se o local selecionado ja está marcado com "X" ou "O"
        if @board[spot] != "X" && @board[spot] != "O"
          @board[spot] = @com
        else
          spot = nil
        end
      end
      puts "COMPUTER MOVE: => #{spot}"
      sleep(2)
    end
  end

  def get_best_move(board)
    available_spaces = []
    best_move = nil
    board.each do |s|
      if s != "X" && s != "O"
        available_spaces << s
      end
    end
    available_spaces.each do |as|
      #Checa se há alguma posição que caso o computador marque, o computador irá vencer
      board[as.to_i] = @com
      if game_is_over(board)
        best_move = as.to_i
        board[as.to_i] = as
        puts "That was a winning move"
        return best_move
      else
        #Checa se há alguma posição que caso o humano marque, o humano irá vencer
        board[as.to_i] = @hum
        if game_is_over(board)
          best_move = as.to_i
          board[as.to_i] = as
          puts "That was a defense move"
          return best_move
        else
          board[as.to_i] = as
        end
      end
    end
    if best_move
      return best_move
    else
      puts "That was a random move"
      n = rand(0..available_spaces.count)
      return available_spaces[n].to_i
    end
  end

  def game_is_over(b)
    #Checa se algum dos casos de vitória foi atingido
    [b[0], b[1], b[2]].uniq.length == 1 ||
    [b[3], b[4], b[5]].uniq.length == 1 ||
    [b[6], b[7], b[8]].uniq.length == 1 ||
    [b[0], b[3], b[6]].uniq.length == 1 ||
    [b[1], b[4], b[7]].uniq.length == 1 ||
    [b[2], b[5], b[8]].uniq.length == 1 ||
    [b[0], b[4], b[8]].uniq.length == 1 ||
    [b[2], b[4], b[6]].uniq.length == 1

  end

  def tie(b)
    if b.all? { |s| s == "X" || s == "O" }
      puts "It's a tie!"
      return true
    else
      return false
    end
  end

end
