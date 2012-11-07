require_relative 'game'

describe Game do
  let(:game_def) do
    {
      :entrance => {
        :location => [0, 0],
        :entrance? => true
      },
      :south_room => {
        :location => [0, 1]
      },
      :room3 => {
        :location => [1, 1]
      }
    }
  end

  subject { Game.new(game_def) }

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
      b = subject.room(:room1) do
        location [0, 0]
        text "This is a great room. There is a strange door to the left"
      end
      b.attributes[:location].should == [0, 0]
      b.attributes[:text].should =~ /^This is a great room/
    end
  end
end

