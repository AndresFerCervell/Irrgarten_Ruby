require_relative 'directions'
require_relative 'orientation'
require_relative 'game_character'
require_relative 'weapon'
require_relative 'shield'
require_relative 'dice'
require_relative 'game_state'
#encoding: utf-8
module Irrgarten
  class TestP1
    def self.main
      puts "Probando enumerados"
      dir = Directions:: UP
      ori = Orientation:: VERTICAL
      character = GameCharacter:: MONSTER
      puts "Dirección: #{dir}"
      puts "Orientación: #{ori}"
      puts "Personaje: #{character}"
      
      puts "Probando clases Weapon y Shield"
      sword = Weapon.new(2.5, 3)
      wooden_shield = Shield.new(1.5, 2)
      
      puts "Arma inicial: #{sword.to_s}"
      puts "Escudo inicial: #{wooden_shield.to_s}"
      
      puts "Ataque 1: #{sword.attack} -> Estado: #{sword.to_s}"
      puts "Ataque 2: #{sword.attack}"
      puts "Ataque 3: #{sword.attack}"
      puts "Ataque 4 (sin usos): #{sword.attack} -> Estado: #{sword.to_s}"

      puts "Defensa 1: #{wooden_shield.protect} -> Estado:  #{wooden_shield.to_s}"
      puts "Defensa 2: #{wooden_shield.protect}"
      puts "Defensa 3 (sin usos): #{wooden_shield.protect} -> Estado: #{wooden_shield.to_s}"
      
      puts "Probando clase GameState"
      state = GameState.new("Laberinto1", "Jugador1", "Monstruo1", 0, false, "Inicio del juego.")
      puts "Labyrinth: #{state.labyrinth}"
      puts "Players: #{state.players}"
      puts "Monsters: #{state.monsters}"
      puts "CurrentPlayer: #{state.current_player}"
      puts "Winner: #{state.winner}"
      puts "Log: #{state.log}"
      
      puts "Probando clase Dice"
      
      resurrections = 0
      max_uses_discarded = 0
      zero_uses_discarded = 0
      max_weapons_reward = -1
      max_intelligence = -1.0
      
      100.times do
        resurrections += 1 if Dice.resurrect_player
        max_uses_discarded += 1 if Dice.discard_element(5)
        zero_uses_discarded += 1 if Dice.discard_element(0)
        
        rew = Dice.weapons_reward
        max_weapons_reward = rew if rew > max_weapons_reward
        
        intel = Dice.random_intelligence
        max_intelligence = intel if intel > max_intelligence
      end
      
      puts "ResurrectPlayer (Prob 30%): Resucitado #{resurrections} veces de 100."
      puts "DiscardElement con usos al MAX (5): #{max_uses_discarded} veces. (Esperado: 0)"
      puts "DiscardElement con usos en 0: #{zero_uses_discarded} veces. (Esperado: 100)"
      puts "Máxima recompensa de armas: #{max_weapons_reward} (<= 2)"
      puts "Máxima inteligencia: #{max_intelligence} (< 10.0)"
      
    end
  end
  TestP1.main  
end


  
