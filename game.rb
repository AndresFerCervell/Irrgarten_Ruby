#encoding:utf-8
require_relative 'dice'
require_relative 'player'
require_relative 'labyrinth'
require_relative 'game_state'
require_relative 'game_character'
require_relative 'fuzzy_player'
module Irrgarten
  class Game
    @MAX_ROUNDS = 10
    class << self
      attr_reader :MAX_ROUNDS
    end
    
    def initialize(n_players)
      @players = Array.new
      for i in 0... n_players
        number = (i + '0'.ord).chr
        player = Player.new(number, Dice.random_intelligence, Dice.random_strength)
        @players.push(player)
      end
      @monsters = Array.new
  
      @current_player_index = Dice.who_starts(n_players)
      @current_player = @players[@current_player_index]
      @labyrinth = Labyrinth.new(5, 5, 4, 4)
      @log = ""
      configure_labyrinth
      @labyrinth.spread_players(@players)
    end
    
    def finished
      @labyrinth.have_a_winner
    end
    
    def next_step(preferred_direction)
      @log = ""
      dead = @current_player.dead
      if !dead
        direction = actual_direction(preferred_direction)
        if direction != preferred_direction
          log_player_no_orders
        end
        monster = @labyrinth.put_player(direction, @current_player)
        if monster == nil
          log_no_monster
        else
          winner = combat(monster)
          manage_reward(winner)
        end
        else
        manage_resurrection
        end
        end_game = finished
        if !end_game
          next_player
        end
        end_game
        
    end
    
    def game_state
      cad_players = ""
      for i in 0...@players.size  
        cad_players += @players[i].to_s + "\n"
      end
      cad_monsters = ""
      for i in 0...@monsters.size 
        cad_monsters += @monsters[i].to_s + "\n"
      end
      GameState.new(@labyrinth.to_s, cad_players, cad_monsters, @current_player_index, finished, @log)
    end
    
    private
    
    def configure_labyrinth
      # Muros (Asegúrate de tener Orientation::HORIZONTAL/VERTICAL definidos)
      @labyrinth.add_block(Orientation::HORIZONTAL, 1, 0, 4)
      @labyrinth.add_block(Orientation::HORIZONTAL, 3, 1, 4)

      # Monstruos
      m1 = Monster.new("Eslime", 32.0, 2.0)
      m2 = Monster.new("Guerrero", 30.0, 5.0)
      m3 = Monster.new("Gorgona", 30.0, 8.0)

      @labyrinth.add_monster(0, 4, m1)
      @labyrinth.add_monster(2, 0, m2)
      @labyrinth.add_monster(4, 3, m3)

      @monsters << m1 << m2 << m3
    end
  
  def next_player
    @current_player_index = (@current_player_index + 1) % @players.size
    @current_player = @players[@current_player_index]
  end
  
  def actual_direction(preferred_direction) 
    current_row = @current_player.row
    current_col = @current_player.col
    valid_moves = @labyrinth.valid_moves(current_row, current_col)
    @current_player.move(preferred_direction, valid_moves)
  end
  
  def combat(monster)
    rounds = 0
    winner = GameCharacter::PLAYER
    player_attack = @current_player.attack
    lose = monster.defend(player_attack)
    while !lose && rounds < self.class.MAX_ROUNDS
      winner = GameCharacter::MONSTER
      rounds += 1
      monster_attack = monster.attack
      lose = @current_player.defend(monster_attack)
      if !lose
        player_attack = @current_player.attack
        winner = GameCharacter::PLAYER
      
        lose = monster.defend(player_attack)
      end
    end
    log_rounds(rounds, self.class.MAX_ROUNDS)
    winner
  end
  
  def manage_reward(winner)
    if winner == GameCharacter::PLAYER
      @current_player.receive_reward
      log_player_won
    else
      log_monster_won
    end     
  end
  
  def manage_resurrection()
    resurrect = Dice.resurrect_player
    if resurrect
      @current_player.resurrect
      change_players(@current_player)
      log_resurrected
    else
      log_player_skip_turn
    end
  end
  
def log_player_won
    @log += @current_player.name + " Ha ganado el combate" + "\n"
  end

  def log_monster_won
    @log += "El monstruo ha ganado el combate" + "\n"
  end

  def log_resurrected
    @log += @current_player.name + " Ha resucitado" + "\n"
  end

  def log_player_skip_turn
    @log += @current_player.name + " Ha perdido el turno por estar muerto" + "\n"
  end

  def log_player_no_orders
    @log += @current_player.name + " No ha seguido las instrucciones del jugador humano" + "\n"
  end

  def log_no_monster
    @log += @current_player.name + " Se ha movido a una celda vacia o no ha podido moverse" + "\n"
  end

  def log_rounds(rounds, max)
    @log += "Ronda: " + rounds.to_s + "/" + max.to_s + "\n"
  end
  
  def change_players(player)
    fuzzy = FuzzyPlayer.new(player)
    @players[@current_player_index] = fuzzy
    @labyrinth.change_players(player, fuzzy)
  end
  end
end

    
      
