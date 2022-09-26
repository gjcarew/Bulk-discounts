require 'holiday_service'
require 'json'

class HolidayFacade
  def self.holidays
    response = HolidayService.holidays
    parsed = JSON.parse(response.body, symbolize_names: true)
    parsed.first(3)
  end
end