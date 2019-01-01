class PF100Packet
  attr_reader :type, :data

  def initialize(type, data = nil)
    if(data) then
      @type = type
      @data = data
      return
    end
    # if we only have one argument then we build a packet from raw data
    @type, @data = from_subpackets(type)
  end

  def self.from_s(data)
    type = data[0].ord & 0xF0 == 0 ? :request : :response
    length = data[0].ord & 0x0F
    out_data = []
    (0..length-1).each do |idx|
      out_data.push data[idx+1].ord
    end
    [type, out_data]
  end

  def from_subpackets(subpackets)
    full_data = []
    type = nil
    subpackets.each do |subpacket|
      type, data = PF100Packet::from_s(subpacket)
      full_data += data
    end
    if(type == :response and full_data[-2] == 79 and full_data[-1] == 75) then
      # strip the OK off the response since it's assumed
      full_data.pop
      full_data.pop
    end
    [type, full_data]
  end

  def to_s
    out = ""
    out[0] = @data.length.chr
    out[0] |= 0xF0 if @type == :response
    (0..6).each do |idx|
      if(@data[idx]) then
        out += @data[idx].chr
      else
        out += 0x00.chr
      end
    end
    out
  end

  def ==(other)
    return false if @type != other.type
    return false if @data != other.data
    true
  end
end

