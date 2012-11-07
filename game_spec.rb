require_relative 'game'

describe Game do
  subject do
    Game.new.tap do |game|
      game.room do
        key :entrance
        connect 's', :south_room
        text "This is the entrance"
      end

      game.room do
        key :south_room
        connect 'n', :entrance
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

  describe "#find_adjoining_rooms" do
    it "finds :south_room from :entrance" do
      subject.find_adjoining_rooms(subject.rooms[:entrance]).should == [subject.rooms[:south_room]]
    end
  end

  describe "RoomBuilder" do
    it "builds a room" do
      room = subject.room do
        key :room1
        connect 's', :south_room
        text "This is a great room. There is a strange door behind you."
      end
      room.connections.should == [{:action => 's', :room => :south_room}]
      room.text.should =~ /^This is a great room/
    end
  end
end

