require 'httparty'

class HolidayService
  def self.holidays
    HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
  end
end