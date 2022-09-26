class Holiday 
  attr_reader :name, :date
  def initialize(hash)
    @name = hash[:name]
    @date = Date.parse(hash[:date])
  end

  def self.next_holidays
    HolidayFacade.holidays.map do |holiday|
      Holiday.new(holiday)
    end
  end
end