#encoding: UTF-8
require_relative 'dice'
module Irrgarten
  #Archivos, métodos y variables en snake_case, clases y módulos en CamelCase
  class Weapon
    def initialize(p,u)
      @power = p
      @uses = u
    end
    attr_reader :power
    def attack()
      if(@uses > 0)
        @uses -=1
        return @power
      else
        return 0.0
      end
    end
    
    def to_s()
      "W[#{@power}, #{@uses}]"
    end
    
    def discard()
      Dice.discard_element(@uses)
    end  
    
  end
end


