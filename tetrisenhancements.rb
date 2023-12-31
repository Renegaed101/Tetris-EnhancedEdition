class MyPiece < Piece

  def self.next_piece (board)
    if board.cheatStatus == true 
      board.cheatStatus = false 
      MyPiece.new(Cheat_Piece.sample,board)
    else
      MyPiece.new(All_Pieces.sample, board)
    end
  end

  All_Pieces = 
  [ 
    [[[0, 0], [1, 0], [0, 1], [1, 1]]],  # square (only needs one)
    rotations([[0, 0], [-1, 0], [1, 0], [0, -1]]), # T
    [[[0, 0], [-1, 0], [1, 0], [2, 0]], # long (only needs two)
    [[0, 0], [0, -1], [0, 1], [0, 2]]],
    rotations([[0, 0], [0, -1], [0, 1], [1, 1]]), # L
    rotations([[0, 0], [0, -1], [0, 1], [-1, 1]]), # inverted L
    rotations([[0, 0], [-1, 0], [0, -1], [1, -1]]), # S
    rotations([[0, 0], [1, 0], [0, -1], [-1, -1]]),
    [[[0,0], [-1,0], [1,0], [2,0], [3,0]], #long 5 (needs only 2)
    [[0,0], [0,-1], [0,1], [0,2], [0,3]]],
    [[[0,0], [0,-1], [1,0]],
    [[0,0], [1,0], [1,-1]],
    [[0,-1], [1,-1], [1,0]],
    [[0,0], [-1,0], [-1,1]]],
    rotations([[0,0], [-1,0], [-1,1], [0,1], [0,2]])  
  ] 

  Cheat_Piece = [[[[0,0]]]]
  
end

class MyBoard < Board
  # Enhancements here:
  attr_accessor :cheatStatus

  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @cheatStatus = false 
  end  

  def next_piece 
    @current_block = MyPiece.next_piece(self)
    @current_pos = nil  
  end

  def cheat 
    if !game_over? and @game.is_running? and @score >= 100 and @cheatStatus == false
      @score = @score - 100
      @cheatStatus = true 
    end
  end

  def rotate_180 
    if !game_over? and @game.is_running?
      @current_block.move(0,0,2)
    end
    draw   
  end

  def store_current
    locations = @current_block.current_rotation
    displacement = @current_block.position
    (0..(locations.size) - 1).each{|index| 
      current = locations[index];
      # puts (locations[index])
      @grid[current[1]+displacement[1]][current[0]+displacement[0]] = 
      @current_pos[index]
    }
    remove_filled
    @delay = [@delay - 2, 80].max
  end
end

class MyTetris < Tetris
  # Enhancements here:

  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
    
  def key_bindings  
    @root.bind('n', proc {self.new_game}) 

    @root.bind('p', proc {self.pause}) 

    @root.bind('q', proc {exitProgram})
    
    @root.bind('a', proc {@board.move_left})
    @root.bind('Left', proc {@board.move_left}) 
    
    @root.bind('d', proc {@board.move_right})
    @root.bind('Right', proc {@board.move_right}) 

    @root.bind('s', proc {@board.rotate_clockwise})
    @root.bind('Down', proc {@board.rotate_clockwise})

    @root.bind('w', proc {@board.rotate_counter_clockwise})
    @root.bind('Up', proc {@board.rotate_counter_clockwise}) 
    
    @root.bind('space' , proc {@board.drop_all_the_way}) 

    @root.bind('u' , proc {@board.rotate_180})

    @root.bind('c', proc {@board.cheat})
  end

end


