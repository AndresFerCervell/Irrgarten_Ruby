#encoding: UTF-8
module Irrgarten
class LabyrinthCharacter
  @INVALID_POS = -1
  
  class << self
      attr_reader :INVALID_POS
  end
  
  def initialize(name, intelligence, strength, health)
    @name = name
    @intelligence = intelligence
    @strength = strength 
    @health = health
    set_pos(LabyrinthCharacter.INVALID_POS, LabyrinthCharacter.INVALID_POS)
  end
  
  def new_copy(other)
    @name = other.name
    @intelligence = other.intelligence
    @strength = other.strength 
    @health = other.health
    set_pos(other.row, other.col)
    
  end
  
  def dead
    @health <= 0
  end
  
  
  attr_reader :row, :col, :name
  
  protected
  
  attr_reader :intelligence, :strength, :health 
  
  attr_writer :health
  
  public
  def set_pos(row, col)
    @row = row
    @col = col
  end
  
  def to_s
    formato='%.6f'
    "#{@name}[i:#{format(formato,@intelligence)}, s:#{format(formato,@strength)}, "+
            "h:#{format(formato,@health)}, p:(#{@row}, #{@col})]"
  end
  
  protected
  def got_wounded
    @health = @health - 1
  end
  
  def attack
    raise NotImplementedError
  end
  
  def defend
    raise NotImplementedError 
  end
end
end

    
