require './board.rb'
class Minesweeper < Board
  REGEX = /^[of]\(\d+,\d+\)/
  def initialize(size,level)
    @size = size
    @level = level.upcase
    @revealed = Array.new(size) { Array.new(size)}
    @flagged = Array.new(size) { Array.new(size)}
    @status = "RUNNING"
    super(@size,@level)
    @total_correct_tiles = (@size*@size) - @num_of_mines
    start
  end

  def display_revealed
    @size.times do |i|
      @size.times do |j|
        x = @setup[i][j]
        print x
      end
      puts "\n"
    end
  end

  def display_hidden
    @size.times do |i|
      @size.times do |j|
        if @revealed[i][j]
          print @setup[i][j]
        elsif @flagged[i][j]
          print "f"
        else
          print "*"
        end
      end
      puts "\n"
    end
  end

  def start
    puts "Options to play - "
    puts "1. open a tile - o(x,y)"
    puts "2. flag a tile - f(x,y)"
    puts "3. exit game and get answer - type exit"
    while(@status == "RUNNING")
      puts "Enter the option: "
      option = gets.chomp
      if (option == "exit".downcase)
        @status = "STOP"
        exit_minesweeper
      else
        if (!REGEX.match(option).nil?)
          if (option.split('(')[0] == "o")
            open(get_coordinates(option))
          elsif (option.split('(')[0] == "f")
            flag(get_coordinates(option))
          end
        else
          puts "***Please enter correct option*** \n"
        end
      end
      if check_win
        @status = "STOP"
        puts "Wow! You have cleared the minefield! Game over!"
      end
      display_hidden
    end
  end

  def open(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    if @setup[x][y] == "x"
      puts "OOPS you stepped on a mine!! Game over!!"
      exit_minesweeper
    else
      @revealed[x][y] = true
      reveal_blank(x,y)
    end
  end

  def flag(coordinates)
    x = coordinates[0]
    y = coordinates[1]
    @flagged[x][y] = true
  end

  def reveal_blank(i,j)
    (-1..1).each do |x|
      (-1..1).each do |y|
        if (i+x) >= 0 && (j+y) >= 0 && (i+x) < @size && (j+y) < @size
          if @setup[i+x][j+y] == 0
            @revealed[i+x][j+y] = true
          end
        end
      end
    end
  end

  def check_win
    checked_tiles = 0
    @size.times do |i|
      @size.times do |j|
        if @revealed[i][j] && !@mines.include?([i,j]) && !@flagged[i][j]
          checked_tiles += 1
        end
      end
    end
    checked_tiles == @total_correct_tiles ? true : false
  end

  def get_coordinates(string)
    x = string.split('(')[1][0].to_i
    y = string.split(')')[0][-1].to_i
    if x >= @size || y >= @size
      error
    end
    return x,y
  end

  def exit_minesweeper(show_error=nil)
    puts "***Please enter correct values*****" if show_error
    puts "Thanks for playing. Answer - "
    display_revealed
    exit
  end
end

puts "Enter the size of the board:"
input_size = gets.chomp.to_i
if input_size == 0
  abort("***Please enter correct values****")
end
puts "Enter level of the game (Easy: E, Medium: M, Hard: H) :"
input_level = gets.chomp
mine = Minesweeper.new(input_size, input_level)
