class Game
  class RoomBuilder
    attr_accessor :key, :attributes

    def initialize
      @attributes = {
        :key      => nil,
        :location => nil,
        :entrance => false
      }
    end

    def self.build(proc)
      b = RoomBuilder.new
      b.instance_eval(&proc)
      b.attributes[:key] or raise "Room needs a key name"
      b.attributes[:location] or raise "Room needs a location"
      b.attributes[:text] or raise "Room needs a text description (text)"
      b
    end

    def key(k)
      @attributes[:key] = k
    end

    def location(x, y)
      @attributes[:location] = [x, y]
    end

    def text(t)
      @attributes[:text] = t
    end

    def entrance(e)
      @attributes[:entrance] = e
    end
  end
end

