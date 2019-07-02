# frozen_string_literal: true
class Twilio::Phone::FavouriteNumberTree < Twilio::Phone::BaseTree
  voice "male"

  greeting message: "Hello", prompt: :favourite_number

  prompt :favourite_number,
    message: "Please enter your favourite number.",
    gather: {
      type: :digits,
      timeout: 10,
      number: 1,
    },
    after: {
      prompt: :second_favourite_number,
      message: "Thank you for your selection."
    }

  prompt :second_favourite_number,
    message: "Please enter your second favourite number.",
    gather: {
      type: :digits,
      timeout: 10,
      number: 1,
    },
    after: ->(response) {
      prev_fav = response.phone_call.responses.find_by(prompt: "favourite_number")

      if prev_fav.digits == response.digits
        {
          prompt: :second_favourite_number,
          message: "You cannot select the same number twice."
        }
      else
        {
          prompt: :favourite_number_reason,
          message: "Thank you for answering #{response.digits}"
        }
      end
    }

  prompt :favourite_number_reason,
    message: "Please explain your reason after the tone.",
    gather: {
      type: :voice,
      length: 4,
      transcribe: true,
    },
    after: {
      hangup: true,
      message: "Thank you for your time",
    }
end
