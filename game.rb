require_relative 'game/room'
require_relative 'game/room_builder'

class Game
  attr_accessor :rooms

  def initialize
    @rooms = {}
  end

  def room(&block)
    b = RoomBuilder.build(block)
    room = Room.new(b.attributes)
    @rooms[room.key] = room
    room
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

