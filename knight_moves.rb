module Chess

  class Board 
    attr_accessor :board

    def initialize
      @board = []
    end

    def create_board
      for x in  0..7 do
        for y in 0..7 do
          @board << [x, y]
        end
      end
    end

  end

  class KnightMove
    attr_accessor :move, :next_moves, :parent_move

    def initialize(move, parent_move=nil)
      @move = move
      @next_moves = []
      @parent_move = parent_move
    end
  end
  
  class Knight
    attr_accessor :board, :move_root
    
    def initialize
      @moves = []
      @move_root = nil
      @move_list = []
      @target_node = nil
      @number_of_moves = 0
    end

    def knight_moves(start_square, target_square)
      @move_root = KnightMove.new(start_square)
      create_move_graph(target_square)
      find_target_square(target_square, @move_root)
      find_move_path(@target_node)
      puts "You made it in #{@number_of_moves} moves! Here's your path:"
      until @move_list.empty?
        p @move_list.shift
      end
    end
    
    def create_move_graph(target_square)
      # using a queue to work through coordinates until the target is found.
      # creating a directed graph that spreads out from a single point until
      # a leaf node produces the target, in which case the graph ceases to continue
      # to build
      queue = []
      queue << @move_root
      until queue.empty?
        current_node = queue.shift
        possible_moves = possible_moves(current_node.move)
        add_to_move_list(possible_moves, current_node)
        if possible_moves.include?(target_square)
          break
        else
          current_node.next_moves.each { |move_node| queue << move_node}
        end
      end
    end
    
    def find_target_square(target_square, node)
      # using depth first search to find the target node and store it
      if node.next_moves.empty? 
        return
      else
        for node in node.next_moves do 
          if node.move == target_square
            @target_node = node
          end
          find_target_square(target_square, node)
        end
      end
    end

    def find_move_path(node)
      # using recursion to travel back up the graph following the assigned
      # parent nodes from the target leaf node back to the root node,  
      # tracing the number of steps back to the leaf node
      if node.parent_move.nil?
        @move_list << node.move
        return
      else
        find_move_path(node.parent_move)
        @number_of_moves += 1
        @move_list << node.move
      end
    end

    def add_to_move_list(possible_moves, start_square)
      possible_moves.each do |value|
        start_square.next_moves << KnightMove.new(value, start_square)
      end
    end
    
    def possible_moves(start_square)
      moves = []
      x = start_square[0]
      y = start_square[1]
      ordinates = [1, -1, 2, -2]
      i = 0
      until i == 4 do 
        if i < 2
          moves << [x + ordinates[i], y + ordinates[2]]
          moves << [x + ordinates[i], y + ordinates[3]]
        else
          moves << [x + ordinates[i], y + ordinates[0]]
          moves << [x + ordinates[i], y + ordinates[1]]
        end
        i += 1
      end
      moves.keep_if { |m| board.board.include?(m) }
      return moves
    end

  end

end

board = Chess::Board.new
board.create_board
knight = Chess::Knight.new
knight.board = board
knight.knight_moves([0, 0], [0, 1])

