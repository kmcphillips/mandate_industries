module ApplicationHelper
  def caller_location(call)
    [
      call.caller_city.presence&.titleize,
      call.caller_province,
      call.caller_country,
    ].reject(&:blank?).join(", ")
  end

  def formatted_phone(number)
    number_to_phone(number, area_code: true)
  end
end
