require 'date'

class PF100Record
  attr_reader :time, :pef, :fev
  def initialize(year, month, day, hour, minute, pef, fev)
    time = sprintf("%d-%02d-%02d %02d:%02d", year, month, day, hour, minute)
    @time = DateTime.parse(time)
    @pef = pef
    @fev = fev
  end
end

