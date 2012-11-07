class Game
  class RoomBuilder
    attr_accessor :key, :room

    def initialize
      @room = Room.new
    end

    def self.build(proc)
      b = RoomBuilder.new
      b.instance_eval(&proc)
      b.room.key or raise "Room needs a key name"
      b.room.connections.empty? and raise "Room needs to connect somewhere"
      b.room.text or raise "Room needs a text description (text)"
      b.room
    end

    def key(k)
      @room.key = k
    end

    def connect(action, room)
      @room.connections << {:action => action, :room => room}
    end

    def text(t)
      @room.text = t
    end

    def entrance(e)
      @room.entrance = e
    end
  end
end

