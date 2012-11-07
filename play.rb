require_relative 'game'

game = Game.new

game.room do
  key :entrance
  connect 'e', :eagle_room
  connect 's', :bear_room
  entrance true
  text "This is the entrance. Let's get started!"
end

game.room do
  key :eagle_room
  connect 'w', :entrance
  connect 'e', :badger_room
  text "This is the eagle room. There are lots of eagles here. Watch them fly!"
end

game.room do
  key :badger_room
  connect 'w', :eagle_room
  text "There are lots of badgers here."
end

game.room do
  key :bear_room
  connect 'n', :entrance
  text "This is the bear room. There is a polar bear here. He looks hungry."
end

game.run

