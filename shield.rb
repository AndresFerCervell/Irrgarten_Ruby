#encoding: UTF-8
module Irrgarten
  class Shield
    def initialize(p,u)
      @protection = p
      @uses = u
    end
    attr_reader :protection
    def protect()
      if(@uses > 0)
        @uses -= 1
        @protection
      else
        0.0
      end
    end
    
    def to_s()
      "S[#{@protection}, #{@uses}]"
    end  
    def discard()
      Dice.discard_element(@uses)
    end   
  end
end
        
