#encoding:utf-8
require_relative 'dice'
module Irrgarten
  class Monster < LabyrinthCharacter
    @INITIAL_HEALTH = 5
    @INVALID_POS = -1
    class << self
      attr_reader :INITIAL_HEALTH, :INVALID_POS
    end
    
    def initialize(name, intelligence, strength)
      super(name, intelligence, strength, self.class.INITIAL_HEALTH)
    end
    
    
       
    def attack
      Dice.intensity(@strength)
    end
    
    
    def to_s
      resultado = "Monster " + super
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
    
    
    
    
      
      
      
