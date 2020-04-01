require 'hidapi'

class PF100Meter
  VENDOR_ID = 0x04b4
  PRODUCT_ID = 0x5500
  
  def initialize
    @connected = false
    connect
  end

  def connect
    @usb = HIDAPI::open(VENDOR_ID, PRODUCT_ID)
    if(!@usb) then
      @connected = false
    else
      @connected = true
      @usb.blocking = false
    end
  end

  def self.setup
    HIDAPI::SetupTaskHelper.new(
      VENDOR_ID,          # vendor_id
      PRODUCT_ID,         # product_id
      "Microlife PF100",  # simple_name
      0                   # interface
    ).run
  end

  def connected?
    @connected
  end

  def send(packet)
    @usb.write packet.to_s
  end

  def receive
    full_data = []
    tries = 4
    while(tries > 0) do
      tries -= 1
      raw_data = @usb.read
      if(!raw_data or raw_data == "") then
        sleep 0.25
        next
      end
      tries += 1
      full_data.push raw_data
      # break if we have "OK" at the end of the last data sub-packet
      type, data = PF100Packet::from_s(raw_data)
      break if full_data[-2..-1] == [79, 75]
    end
    return nil if full_data == ""
    PF100Packet.new(full_data)
  end

  def expect_response(expected_packet)
    response = receive
    return nil if !response or response.type == nil
    return true if response == expected_packet
    # TODO: this should be more elegant
    raise "Received unexpected message from PF100 expected #{expected_packet.data}, got #{response.data} aborting."
    Kernel.exit(2)
  end

  def ping
    ping_pkt = PF100Packet.new(:request, [0x2c, 0x7b, 0x7d])
    send ping_pkt
    pong_pkt = PF100Packet.new(:response, [0x2c, 0x7b, 0x00, 0x01, 0x20, 0x56, 0x7d])
    begin
      expect_response pong_pkt
    rescue Exception => e
      puts e.message
      pong_pkt = PF100Packet.new(:response, [0x2c, 0x7b, 0x00, 0x00, 0x20, 0x56, 0x7d])
      expect_response pong_pkt
      return true
    end
    #return true
  end

  def get_records
    get_records_pkt = PF100Packet.new(:request, [0x2f, 0x7b, 0x7d, 0xf8, 0x4f, 0x60, 0xff])
    send get_records_pkt
    records_pkt = receive
    raw_records = records_pkt.data
    records = Array.new
    while(true)
      record = raw_records.shift(12)
      break if record == []
      puts record
      year = "20#{record[2].to_s(16)}".to_i
      month = record[3].to_s(16).to_i
      day = record[4].to_s(16).to_i
      hour = record[5].to_s(16).to_i
      minute = record[6].to_s(16).to_i
      pef_right = record[7].to_s(16).to_i
      pef_left = record[8].to_s(16).to_i
      pef = sprintf("%d%02d", pef_left, pef_right).to_i
      fev_right = record[9].to_s(16).to_i
      fev_left = record[10].to_s(16).to_i
      fev = sprintf("%d.%02d", fev_left, fev_right).to_f
      records.push PF100Record.new(year, month, day, hour, minute, pef, fev)
    end
    records
  end

  def clear_all_data
    clear_pkt = PF100Packet.new(:request, [0x2d, 0x7b, 0x7d, 0x7e, 0x53, 0x60, 0xff])
    send clear_pkt
    expect_response PF100Packet.new(:response, [])
  end
end

