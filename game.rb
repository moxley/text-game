class Game
  attr_accessor :rooms

  def initialize(game_def = define_rooms)
    @rooms = game_def
  end

  class RoomBuilder
    attr_accessor :key, :attributes

    def initialize(key)
      key or raise "Room needs a key"
      @key = key
      @attributes = {
        :location => nil,
        :is_entrance => false
      }
    end

    def self.build(key, &block)
      b = RoomBuilder.new(key)
      yield b
      b.attributes[:location] or raise "Room needs a location"
      b
    end

    def location(l)
      @attributes[:location] = l
    end

    def text(t)
      @attributes[:text] = t
    end

    def entrance?(e)
      @attributes[:entrance?] = e
    end
  end

  def build_room(key, &block)
    b = RoomBuilder.build(key) { |b| block.call(b) }
    @rooms[b.key] = b.attributes
    b
  end

  def define_rooms
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

  def entrance
    puts "This the entrance. You can go south"
    puts "Which direction? (s): "
    gets.strip
  end

  def south_room
    puts "This is the South Room. You can go north or east"
    puts "Which direction? (n, e): "
    gets.strip
  end

  def room3
    puts "This is Room 3. You can go west."
    puts "Which direction? (w): "
    gets.strip
  end

  def next_room(source_room, response)
    room_def = rooms[source_room]
    next_x = room_def[:location][0]
    next_y = room_def[:location][1]
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
    puts "next_x: #{next_x}, next_y: #{next_y}"
    room, room_def = rooms.detect do |room, room_def|
      room_def[:location] == [next_x, next_y]
    end
    room
  end

  def find_first_entrance
    room, room_def = rooms.detect do |room, room_def|
      room_def[:entrance?]
    end
    room
  end

  def iterate(room, res = 'q')
    return unless room
    res = send(room)
    if res == 'q'
      puts "Thanks for playing."
      return nil
    end

    room = next_room(room, res)
    unless room
      puts "Not a valid direction: #{res}"
      return nil
    end

    if rooms[room][:entrance?]
      puts "You're back outside!"
      return nil
    end

    room
  end

  def run
    room = find_first_entrance
    while room
      room = iterate(room)
    end
  end
end

