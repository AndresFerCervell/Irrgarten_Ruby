#encoding: utf-8
require_relative 'dice'

module Irrgarten
  class CombatELement
    def initialize(effect, uses)
      @effect = effect
      @uses = uses
    end
    
    protected
    
    def produce_effect
      resultado = 0.0
      if (@uses > 0)
        @uses -= 1
        resultado = @effect
      end
      resultado
    end
    
    public
    
    def discard
      Dice.discard_element(@uses)
    end
    
    def to_s
      "[#{@effect}, #{@uses}]"
    end
    
    
  end
end
