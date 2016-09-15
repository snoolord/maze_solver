require 'byebug'
maze = File.readlines("maze.txt")

# so basically what I want to do is to have a good_moves array and open_moves array
class Maze
  attr_accessor :grid, :pos, :end

  DIR = [[1,0],[-1,0],[0,1],[0,-1]]

  def initialize(maze = File.readlines("maze.txt"))
    @maze = maze
    @pos = find_starting_point
    @prev_moves = []
    @end = find_end_point
  end

  def place_mark(pos,mark)
    i,j=pos
    @maze[i][j] =mark
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

  def check_moves(pos)
    viable_moves = []
    i,j = *pos
    # viable_moves << [i-1,j] if @maze[i-1][j] == " " && !path.include?([i-1,j]) #up
    # viable_moves << [i+1,j] if @maze[i+1][j] == " " && !path.include?([i+1,j]) #down
    # viable_moves << [i, j+1] if @maze[i][j+1] == " " && !path.include?([i,j+1]) #right
    # viable_moves << [i, j-1] if @maze[i][j-1] == " " && !path.include?([i,j-1]) #left
    DIR.each do |x,y|
      viable_moves << [i+x,j+y] if !is_wall?([i+x,j+y]) && in_bounds?([i+x,j+y])
    end
    viable_moves
  end

  def is_wall?(point)
    i,j = point
    @maze[i][j] == "*"
  end
  def in_bounds?(point)
    i,j = point
    positive = (i>=0) && (j>=0)
    in_bound = (i < @maze.length) && (j <@maze[0].length)
    return positive && in_bound
  end

end


class MazeSolver
  attr_accessor :maze

  def initialize(maze)
    @maze = maze
    @good_moves = [@maze.pos]
  end

  def best_move
    display
    viable_moves = @maze.check_moves(@maze.pos)
    moves_with_score = Hash.new(0)
    viable_moves.each do |pos|
      moves_with_score[pos] += function(pos) unless @good_moves.include?(pos)
    end

    @good_moves << moves_with_score.min_by { |k,v| v}[0]
    @maze.pos = moves_with_score.min_by { |k,v| v}[0]
  end

  def as_the_crow_flys(point)
    (@maze.end[0]-point[0]).abs + (maze.end[1]-point[1]).abs
  end

  #this will be our H variable in F= G + H
  #G variable is defined as the length of the path
  def path_length(good_moves)
    @good_moves.length
  end

  def function(point)
    f = as_the_crow_flys(point) + path_length(@good_moves)
  end

  def solve
    until @maze.pos == [1,13]
      p @good_moves
      best_move
    end
    @good_moves.each do |pos|
      @maze.place_mark(pos,"X")
    end
    @maze.display
  end


end
maze = Maze.new
solve = MazeSolver.new(maze)
solve.solve
