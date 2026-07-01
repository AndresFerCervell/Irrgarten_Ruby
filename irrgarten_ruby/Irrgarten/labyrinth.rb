#encoding:utf-8
require_relative 'directions'
require_relative 'orientation'
require_relative 'dice'
require_relative 'monster'
module Irrgarten
  class Labyrinth
    @BLOCK_CHAR = 'X'
    @EMPTY_CHAR = '-'
    @MONSTER_CHAR = 'M'
    @COMBAT_CHAR = 'C'
    @EXIT_CHAR = 'E'
    @ROW = 0
    @COL = 1
    @INVALID_POS = -1
    
    class << self
      attr_reader :BLOCK_CHAR, :EMPTY_CHAR, :MONSTER_CHAR, :COMBAT_CHAR, :EXIT_CHAR, :ROW, :COL, :INVALID_POS
    end
    
    def initialize(n_rows, n_cols, exit_row, exit_col)
      @n_rows = n_rows
      @n_cols = n_cols
      @exit_row = exit_row
      @exit_col = exit_col
      @monsters = Array.new(n_rows) {Array.new(n_cols, nil)}
      @players = Array.new(n_rows) {Array.new(n_cols, nil)}
      @labyrinth = Array.new(n_rows) {Array.new(n_cols, '-')}
      @labyrinth[@exit_row][@exit_col] = 'E'
    end
    
    def spread_players(players)
      for i in 0...players.size
        p = players[i]
        pos = random_empty_pos
        put_player_2D(self.class.INVALID_POS, self.class.INVALID_POS, pos[self.class.ROW], pos[self.class.COL], p)
        end
    end
    
    def have_a_winner
      @players[@exit_row][@exit_col] != nil
    end
    
    def to_s
      cad = ""
      for i in 0...@n_rows
        for j in 0...@n_cols
          cad = cad + @labyrinth[i][j]
        end
        cad = cad + "\n"
      end
      cad
    end
    
    def add_monster(row, col, monster)
      if(pos_ok(row,col) && empty_pos(row,col))
        @labyrinth[row][col] = self.class.MONSTER_CHAR
        @monsters[row][col] = monster
        monster.set_pos(row,col)
      end
    end
    
    def put_player(direction, player)
      old_row = player.row
      old_col = player.col
      new_pos = dir_2_pos(old_row, old_col, direction)
      monster = put_player_2D(old_row, old_col, new_pos[self.class.ROW], new_pos[self.class.COL], player)
    end
    
    def add_block(orientation, start_row, start_col, length)
      if orientation == Orientation::VERTICAL
        inc_row = 1
        inc_col = 0
      else
        inc_row = 0
        inc_col = 1
      end
      row = start_row
      col = start_col
      while pos_ok(row,col) && empty_pos(row,col) && length > 0
        @labyrinth[row][col] = self.class.BLOCK_CHAR
        length -= 1
        row += inc_row
        col += inc_col
      end
    end
    
    def valid_moves(row, col)
      output = Array.new
      if can_step_on(row+1, col)
        output.push(Directions::DOWN)
      end
      if can_step_on(row-1, col)
        output.push(Directions::UP)
      end
      if can_step_on(row, col+1)
        output.push(Directions::RIGHT)
      end
      if can_step_on(row, col-1)
        output.push(Directions::LEFT)
      end
      output
    end
    
    private
    
    def pos_ok(row, col)
      return (0 <= row) && (row < @n_rows) && (0 <= col) && (col < @n_cols)
    end
    
    def empty_pos(row, col)
      @labyrinth[row][col] == self.class.EMPTY_CHAR
    end
    
    def monster_pos(row, col)
      @labyrinth[row][col] == self.class.MONSTER_CHAR
    end
    
    def exit_pos(row, col)
      @labyrinth[row][col] == self.class.EXIT_CHAR
    end
    
    def combat_pos(row, col)
      @labyrinth[row][col] == self.class.COMBAT_CHAR
    end
    
    def can_step_on(row, col)
      pos_ok(row,col) && (empty_pos(row,col) || monster_pos(row, col) || exit_pos(row, col))
    end
    
    def update_old_pos(row, col)
      if pos_ok(row, col)
        if combat_pos(row, col)
          @labyrinth[row][col] = self.class.MONSTER_CHAR
        else
          @labyrinth[row][col] = self.class.EMPTY_CHAR
        end
      end
    end
    
    def dir_2_pos(row,col,direction)
      resultado = Array.new(2)
      resultado[self.class.ROW] = row
      resultado[self.class.COL] = col
      if direction == Directions::UP
        resultado[self.class.ROW] -= 1
      elsif direction == Directions::DOWN
        resultado[self.class.ROW] += 1
      elsif direction == Directions::LEFT
        resultado[self.class.COL] -= 1
      else 
        resultado[self.class.COL] += 1
      end
      resultado
    end
    
    def random_empty_pos()
      empty_pos = false
      resultado = Array.new(2)
      row = 0
      col = 0
      while(!empty_pos)
          row = Dice.random_pos(@n_rows)
          col = Dice.random_pos(@n_cols)
          empty_pos = empty_pos(row, col)
          resultado[self.class.ROW] = row
          resultado[self.class.COL] = col
      end   
      resultado
    end
    
    def put_player_2D(old_row, old_col, row, col, player)
      output = nil
      if can_step_on(row,col)
        if pos_ok(old_row, old_col)
          p = @players[old_row][old_col]
          if p == player
            update_old_pos(old_row, old_col)
            @players[old_row][old_col] = nil
          end
        end
        monster_pos = monster_pos(row, col)
        if monster_pos
          @labyrinth[row][col] = self.class.COMBAT_CHAR
          output = @monsters[row][col]
        else
          number = player.number
          @labyrinth[row][col] = number
        end
      @players[row][col] = player
      player.set_pos(row,col)
      end
      output
    end
    public
    def change_players(player, fuzzy)
      row = player.row
      col = player.col
      if(row == fuzzy.row && col == fuzzy.col)
        @players[row][col] = fuzzy
      end
    end
    
  end
end
    
    
      
