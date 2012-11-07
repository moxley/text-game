class Game
  attr_accessor :rooms

  def initialize
    @rooms = {}
  end

  class Room
    attr_accessor :key, :location, :entrance, :text

    def initialize(attrs)
      defaults = {:key => nil, :location => nil, :entrance => false, :text => nil}
      defaults.each { |k, v| send("#{k}=", attrs.has_key?(k) ? attrs[k] : defaults[k]) }
    end

    def entrance?
      entrance
    end
  end

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

  def room(&block)
    b = RoomBuilder.build(block)
    room = Room.new(b.attributes)
    @rooms[room.key] = room
    b
  end

  def next_room(source_room, response)
    room_def = rooms[source_room]
    next_x = room_def.location[0]
    next_y = room_def.location[1]
    case response
    when 's'
      next_y += 1
    when 'n'
      next_y -= 1
    when 'e'
      next_x += 1
    when 'w'
      next_x -= 1
    end
    room, room_def = rooms.detect do |room, room_def|
      room_def.location == [next_x, next_y]
    end
    room
  end

  def find_first_entrance
    key, room = rooms.detect do |key, room|
      room.entrance?
    end
    key
  end

  def find_room(x, y)
    loc = [x, y]
    key, room = @rooms.detect do |key, room|
      room.location == loc
    end
    room
  end

  def find_adjoining_rooms(room)
    locations = []
    vectors = [[0, -1], [1, 0], [0, 1], [-1, 0]]
    loc = room.location
    x = loc[0]
    y = loc[1]
    found_rooms = vectors.map do |(dx, dy)|
      find_room(x + dx, y + dy)
    end.compact
    found_rooms
  end

  def render(room_key)
    room = @rooms[room_key]
    puts room.text
    adjoining_rooms = find_adjoining_rooms(room)
    directions = adjoining_rooms.map do |r|
      case r.location
      when [room.location[0], room.location[1] - 1]
        'n'
      when [room.location[0] + 1, room.location[1]]
        'e'
      when [room.location[0], room.location[1] + 1]
        's'
      when [room.location[0] - 1, room.location[1]]
        'w'
      end
    end
    puts "You can move any of these directions: #{directions.join(', ')}"
    print '> '
    res = gets.strip
    puts
    res
  end

  def iterate(room_key, res = 'q')
    return unless room_key
    res = render(room_key)
    if res == 'q'
      puts "Thanks for playing."
      return nil
    end

    room_key = next_room(room_key, res)
    unless room_key
      puts "Not a valid direction: #{res}"
      return nil
    end

    if rooms[room_key].entrance?
      puts "You're back outside!"
      return nil
    end

    room_key
  end

  def run
    room = find_first_entrance
    while room
      room = iterate(room)
    end
  end
end

