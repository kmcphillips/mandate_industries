module ApplicationHelper
  def caller_location(phone_call)
    [
      phone_call.caller_city.presence&.titleize,
      phone_call.caller_province,
      phone_call.caller_country,
    ].reject(&:blank?).join(", ")
  end

  def formatted_phone(number)
    number_to_phone(number, area_code: true)
  end

  def link_to_formatted_phone(number)
    link_to(formatted_phone(number), "tel:#{number.gsub('+', '')}")
  end
end
