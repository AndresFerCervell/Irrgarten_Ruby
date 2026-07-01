#encoding: UTF-8
require_relative 'combat_element'
module Irrgarten
  class Shield < CombatELement
    def initialize(p,u)
      super
    end
    
    def protect()
      self.produce_effect
    end
    
    def to_s()
      "S" + super
    end  
    
  end
end
        
