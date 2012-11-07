class Game
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
end

