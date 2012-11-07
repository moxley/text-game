require_relative 'game/room'
require_relative 'game/room_builder'

class Game
  attr_accessor :rooms

  def initialize
    @rooms = {}
  end

  def room(&block)
    RoomBuilder.build(block).tap { |room| @rooms[room.key] = room }
  end

  def next_room(source_room, response)
    room = rooms[source_room]
    conn = room.connections.detect do |c|
      c[:action] == response
    end
    conn && conn[:room]
  end

  def find_first_entrance
    key, room = rooms.detect do |key, room|
      room.entrance?
    end
    key
  end

  def render(room_key)
    room = @rooms[room_key]
    puts room.text
    directions = room.connections.map { |c| c[:action] }
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

