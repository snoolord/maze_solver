maze = File.readlines("maze.txt")

class Maze
  attr_accessor :grid

  def initialize(maze = File.readlines("maze.txt"))
    @maze = maze
    @pos = find_starting_point
    @prev_moves = []
    @end = find_end_point
    @short_path = 10000
    @shortest_path = []
  end

  def solve
    display

    check_moves(@pos, [@pos])
  end
  def display
    @maze.each do |line|
      puts line
    end
  end

  def find_starting_point
    @maze.each_with_index do |line,index1|
      line.split('').each_with_index do |char, index2|
        if char == 'S'
          return [index1,index2]
        end
      end
    end
  end

  def find_end_point
    @maze.each_with_index do |line,index1|
      line.split('').each_with_index do |char, index2|
        if char == 'E'
          return [index1,index2]
        end
      end
    end
  end

  def check_moves(pos,path)
    i,j = *pos
    viable_moves = []
    # up = pos[0] < (@maze.length)/2
    # right = pos[1] > (@maze[0].length)/2
    if i == 1 && j == 13
      if path.length < @short_path
        p path
        @short_path = path.length
        @shortest_path = path
      end
      path = []
    end
    if @short_path < path.length
        return
    end
    viable_moves << [i-1,j] if @maze[i-1][j] == " " && !path.include?([i-1,j]) #up
    viable_moves << [i+1,j] if @maze[i+1][j] == " " && !path.include?([i+1,j]) #down
    viable_moves << [i, j+1] if @maze[i][j+1] == " " && !path.include?([i,j+1]) #right
    viable_moves << [i, j-1] if @maze[i][j-1] == " " && !path.include?([i,j-1]) #left
    viable_moves.each do |pos|
      path << pos
      @prev_moves << pos
      check_moves(pos,path)
    end
      # viable_moves.each do |pos|
      #   check_moves(pos)
      # end
  end

end

solve = Maze.new(maze)
solve.solve
