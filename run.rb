require_relative 'game'

game = Game.new

game.room do
  key :entrance
  location 0, 0
  entrance true
  text "This is the entrance. Let's get started!"
end

game.room do
  key :eagle_room
  location 1, 0
  text "This is the eagle room. There are lots of eagles here. Watch them fly!"
end

game.room do
  key :badger_room
  location 2, 0
  text "There are lots of badgers here."
end

game.room do
  key :bear_room
  location 0, 1
  text "This is the bear room. There is a polar bear here. He looks hungry."
end

game.run

