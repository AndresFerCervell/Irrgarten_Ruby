#encoding:utf-8
require_relative 'dice'
module Irrgarten
  class FuzzyPlayer < Player
    def initialize(other)
      self.new_copy(other)
    end
    
    def move(direction, valid_moves)
      Dice.next_step(super, valid_moves, @intelligence)
    end
    
    def attack
      self.sum_weapons + Dice.intensity(@strength)
    end
    
    protected
    def defensive_energy
      self.sum_shields + Dice.intensity(@intelligence)
    end
    
    public 
    def to_s
      "Fuzzy" + super
    end
    
  end
end
