require_relative 'game'

describe Game do
  subject do
    Game.new.tap do |game|
      game.room do
        key :entrance
        location 0, 0
        text "This is the entrance"
      end

      game.room do
        key :south_room
        location 0, 1
        text "This is the south room"
      end
    end
  end

  describe "#next_room" do
    it "returns the correct room for a valid direction" do
      source_room = :entrance
      response = 's'
      room = subject.next_room(source_room, response)
      room.should == :south_room
    end

    it "returns nil for an invalid direction" do
      source_room = :entrance
      response = 'e'
      room = subject.next_room(source_room, response)
      room.should == nil
    end
  end

  describe "RoomBuilder" do
    it "builds a room" do
      room = subject.room do
        key :room1
        location 0, 0
        text "This is a great room. There is a strange door to the left"
      end
      room.location.should == [0, 0]
      room.text.should =~ /^This is a great room/
    end
  end
end

