# frozen_string_literal: true
class Twilio::Phone::FavouriteNumberTree < Twilio::Phone::BaseTree
  voice "male"

  greeting message: "Hello, and thank you for calling Mandate Industries Incorporated!",
    prompt: :favourite_number

  prompt :favourite_number,
    message: "Using the keypad on your touch tone phone, please enter your favourite number.",
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
    message: "In the case that your favourite number is not available, please enter your second favourite number.",
    gather: {
      type: :digits,
      timeout: 10,
      number: 1,
    },
    after: ->(response) {
      prev_fav = response.phone_call.responses.find_by(prompt_handle: "favourite_number")

      if prev_fav.digits == response.digits
        {
          prompt: :second_favourite_number,
          message: "Sorry, but your second favourite number cannot be the same as your first.",
        }
      else
        {
          prompt: :favourite_number_reason,
          message: "Your favourite numbers have been recorded. The numbers #{response.digits} and #{prev_fav.digits}",
        }
      end
    }

  prompt :favourite_number_reason,
    message: "Now, please state after the tone your reason for picking those numbers as your favourites.",
    gather: {
      type: :voice,
      length: 4,
      # transcribe: true, # TODO
    },
    after: {
      hangup: true,
      message: "Thank you for your input! We have made a note of your reasons. Your opinion is important to us and will be disregarded.
        Mandate Industries appreciates your business.",
    }
end
