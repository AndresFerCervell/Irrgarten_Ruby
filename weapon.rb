#encoding: UTF-8
require_relative 'dice'
require_relative 'combat_element'
module Irrgarten
  #Archivos, métodos y variables en snake_case, clases y módulos en CamelCase
  class Weapon < CombatELement
    def initialize(p,u)
      super
    end
   
    def attack()
      self.produce_effect
    end
    
    def to_s()
      "W" + super
    end
    
    
    
  end
end


