
class Board
  attr_accessor :size, :mines, :level, :setup
  def initialize(size, level)
    @num_of_mines = 0
    @mines = []
    @size = size
    @level = level
    @setup = Array.new(size) { Array.new(size)}
    set_number_of_mines
    set_random_mines
    set_tile_values
  end

  def set_number_of_mines
    if @level == "E"
      @num_of_mines = (0.25*@size*@size).to_i
    elsif @level == "M"
      @num_of_mines = (0.50*@size*@size).to_i
    elsif @level == "H"
      @num_of_mines = (0.75*@size*@size).to_i
    else
      error
    end
  end

  def set_random_mines
    selected_mines = 0
    while(selected_mines < @num_of_mines)
      x = rand(@size)
      y = rand(@size)
      mine_coordinates = [x,y]
      if @mines.include?(mine_coordinates)
        next
      else
        @mines << mine_coordinates
        @setup[x][y] = "x"
        selected_mines += 1
      end
    end
  end

  def set_tile_values
    @size.times do |i|
      @size.times do |j|
        if @mines.include?([i,j])
          next
        else
          @setup[i][j] = get_num_of_adjacent_mines(i,j)
        end
      end
    end
  end

  def get_num_of_adjacent_mines(i,j)
    adjacent_mines = 0
    (-1..1).each do |x|
      (-1..1).each do |y|
        if (i+x) >= 0 && (j+y) >= 0 && (i+x) < @size && (j+y) < @size
          if setup[i+x][j+y] == "x"
            adjacent_mines += 1
          end
        end
      end
    end
    adjacent_mines
  end

  def error
    puts "*****please enter correct values*****"
  end
end

class Minesweeper < Board
  attr_accessor :size, :level, :status, :revealed, :flagged
  def initialize(size,level)
    @size = size
    @level = level.upcase
    @revealed = Array.new(size) { Array.new(size)}
    @flagged = Array.new(size) { Array.new(size)}
    @status = "RUNNING"
    super(@size,@level)
    start
  end

  def display_revealed
    puts "Revealed board:"
    @size.times do |i|
      @size.times do |j|
        x = @setup[i][j]
        print x
      end
      puts "\n"
    end
  end

  def display_hidden(revealed)
    @size.times do |i|
      @size.times do |j|
        if !revealed[i][j].nil?
          print @setup[i][j]
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
    puts "exit game and get answer - type exit"
    while(@status == "RUNNING")
      puts "Enter the option: "
      option = gets.chomp
      if (option == "exit".downcase)
        @status = "STOP"
        exit_minesweeper
      else
        if (option.split('(') == "o")
          open(get_coordinates(option))
        elsif (option.split('(') == "f")
          flag(get_coordinates(option))
        else
          puts "Please enter correct option"
        end
      end
    end
  end

  def open(coordinates)
    x = coordinates[0]
    y = coordinates[0]
    if @setup[x][y] == "x"
      puts "OOPS you stepped on a mine!! Game over!!"
      exit_minesweeper
    else
      @revealed[x,y] = true
    end
  end

  def flag(coordinates)
    x = coordinates[0]
    y = coordinates[0]
    @flagged[x][y] = true
  end

  def get_coordinates(string)
    x = string.split('(')[1][0].to_i
    y = string.split(')')[0][-1].to_i
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
puts "Enter level of the game (Easy: E, Medium: M, Hard: H) :"
input_level = gets.chomp
mine = Minesweeper.new(input_size, input_level)
