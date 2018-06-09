
class Board
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
          if @setup[i+x][j+y] == "x"
            adjacent_mines += 1
          end
        end
      end
    end
    adjacent_mines
  end

  def error
    abort("***Please enter correct values****")
  end
end
