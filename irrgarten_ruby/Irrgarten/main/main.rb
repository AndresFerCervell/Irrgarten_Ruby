require_relative '../game'
require_relative '../ui/textUI'
require_relative '../controller/controller'

module Main
  game = Irrgarten::Game.new(1)
  view = UI::TextUI.new
  controller = Control::Controller.new(game, view)

  controller.play
end
