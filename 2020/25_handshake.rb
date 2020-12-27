class Device
  attr_accessor :public_key

  PUBLIC_KEY_SUBJECT = 7
  MOD_VALUE = 20201227

  def initialize(public_key)
    @public_key = public_key
  end

  def loop_size
    @loop_size ||= begin
      value = 1
      (1..).find do |loop|
        value *= PUBLIC_KEY_SUBJECT
        value %= MOD_VALUE

        value == @public_key
      end
    end
  end

  def hash(value)
    result = 1
    loop_size.times do
      result *= value
      result %= MOD_VALUE
    end
    result
  end
end

class Handshake
  def initialize(card_key, door_key)
    @card = Device.new(card_key)
    @door = Device.new(door_key)
  end

  def encryption_key
    # [@card.loop_size, @door.loop_size]
    @card.hash(@door.public_key)
  end
end

if __FILE__ == $0
  p Handshake.new(5764801, 17807724).encryption_key
  p Handshake.new(11239946, 10464955).encryption_key
end
