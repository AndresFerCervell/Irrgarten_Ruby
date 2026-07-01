#encoding:utf-8
require_relative 'dice'
require_relative 'weapon'
require_relative 'shield'
require_relative 'labyrinth_character'
module Irrgarten
  class Player < LabyrinthCharacter
    @MAX_WEAPONS = 2
    @MAX_SHIELDS = 3
    @INITIAL_HEALTH = 10
    @HITS2LOSE = 3
    @INVALID_POS = -1
    class << self
      attr_reader :INITIAL_HEALTH, :INVALID_POS, :MAX_WEAPONS, :MAX_SHIELDS, :INITIAL_HEALTH, :HITS2LOSE
    end
    def initialize(number, intelligence, strength)
             
      @number = number
      super( number, intelligence, strength, Player.INITIAL_HEALTH)
      
      @consecutive_hits = 0
      @weapons = Array.new()
      @shields = Array.new()
    end
    
    attr_reader :number, :consecutive_hits, :weapons, :shields
    def new_copy(other)
      super
      @consecutive_hits = other.consecutive_hits
      @weapons = other.weapons
      @shields = other.shields
      @number = other.number
    end
    def resurrect
      @consecutive_hits = 0
      @health = Player.INITIAL_HEALTH
      @weapons.clear
      @shields.clear
    end
    
     
    
    
    
    def attack
      resultado = @strength + sum_weapons
    end
    
    def defend(received_attack)
      manage_hit(received_attack)
    end
        
    def to_s
      to_weapons="["
            tam_weapons=@weapons.size
            # Se incluye 0 y tam_weapons-1
            for i in 0..(tam_weapons-1) do
                to_weapons+=@weapons[i].to_s

                # NO hace la parte de delante si i == (tam_weapons-1)
                to_weapons += ", " unless i == (tam_weapons - 1)
            end
            to_weapons+="]"

            # Guardamos la info de todas las armas en un string
            to_shields="["
            tam_shields=@shields.size
            # Se incluye 0 y tam_shields-1
            for i in 0..(tam_shields-1) do
                to_shields+=@shields[i].to_s

                # NO hace la parte de delante si i == (tam_weapons-1)
                to_shields += ", " unless i == (tam_shields - 1)
            end
            to_shields+="]"

            return "Player " + super + " [ ch:#{@consecutive_hits}, w:"+to_weapons+", sh:"+to_shields + " ]"
        end

    
    def move(direction, valid_moves)
      size = valid_moves.size
      contained = valid_moves.include?(direction)
      if size > 0 && !contained
        first_element = valid_moves[0]
        return first_element
      else
        return direction
      end
    end
    
    def receive_reward
      
      w_reward = Dice.weapons_reward
      s_reward = Dice.shields_reward
      for i in 0...w_reward
        wnew = new_weapon
        receive_weapon(wnew)
      end
      for i in 0...s_reward
        snew = new_shield
        receive_shield(snew)
      end
      extra_health = Dice.health_reward
      @health += extra_health
    end  
    
    private
    def receive_weapon(w)
      # Elimina todas las armas que deban ser descartadas
      @weapons.delete_if { |wi| wi.discard }
      
      if @weapons.size < Player.MAX_WEAPONS
        @weapons.push(w)
      end
   end
        
    def receive_shield(s)
      @shields.delete_if{|si| si.discard}
      if @shields.size < Player.MAX_SHIELDS
        @shields.push(s)        
      end
          
    end
    
    def manage_hit(received_attack)
      defense = defensive_energy
      if defense < received_attack
        got_wounded
        inc_consecutive_hits
      else
        reset_hits
      end
      if @consecutive_hits == Player.HITS2LOSE || dead
        reset_hits
        lose = true
      else
        lose = false
      end
      lose      
    end
    
    def new_weapon
      weapon = Weapon.new(Dice.weapon_power, Dice.uses_left)
      
    end
    
    def new_shield
      shield = Shield.new(Dice.shield_power, Dice.uses_left)
      
    end
    
    protected
    def defensive_energy
      resultado = @intelligence + sum_shields
    end
    
    def sum_weapons
      resultado = 0
      for i in 0...@weapons.size 
        resultado += @weapons[i].attack
      end 
      resultado
     end
     
     def sum_shields
      resultado = 0
      for i in 0...@shields.size 
        resultado += @shields[i].protect
      end 
      resultado
    end
    
    private
    
    def reset_hits
      @consecutive_hits = 0
    end
    
   
    def inc_consecutive_hits
      @consecutive_hits += 1
    end
    
    
  end
end
    
