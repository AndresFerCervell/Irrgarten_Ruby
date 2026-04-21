#encoding:utf-8
require_relative 'dice'
module Irrgarten
  class Monster
    @INITIAL_HEALTH = 5
    @INVALID_POS = -1
    class << self
      attr_reader :INITIAL_HEALTH, :INVALID_POS
    end
    
    def initialize(name, intelligence, strength)
      @name = name
      @intelligence = intelligence
      @strength = strength
      @health = self.class.INITIAL_HEALTH
      @row = self.class.INVALID_POS
      @col = self.class.INVALID_POS
    end
    
    
    def dead
      @health <= 0.0
    end
    
    def attack
      Dice.intensity(@strength)
    end
    
    def set_pos(row, col)
      @row = row
      @col = col
    end
    
    def to_s
      resultado = "Monster name= #{@name}. Intelligence = #{@intelligence}. Strength= #{@strength}. Health= #{@health}. Pos= (#{@row}, #{@col})"
    end
      
    def got_wounded
      @health = @health - 1
    end
    
    def defend(received_attack)
      is_dead = dead
      if !is_dead
        defensive_energy = Dice.intensity(@intelligence)
        if defensive_energy < received_attack
          got_wounded
          is_dead = dead
        end
      end
      is_dead
    end
  end
end
    
    
    
    
      
      
      
