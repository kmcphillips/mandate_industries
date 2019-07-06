# frozen_string_literal: true
class Twilio::Phone::FavouriteNumberTree < Twilio::Phone::BaseTree
  voice { "male" }

  timeout_message { |response| "We did not receive your response in time." }

  greeting do
    message { |response| "Hello, and thank you for calling Mandate Industries Incorporated!" }
    prompt :favourite_number
  end

  prompt :favourite_number do
    message "Using the keypad on your touch tone phone, please enter your favourite number."
    gather type: :digits, timeout: 10, number: 1
    after do
      prompt :second_favourite_number
      message { |response| "Thank you for your selection." }
    end
  end

  prompt :second_favourite_number do
    message "In the case that your favourite number is not available, please enter your second favourite number."
    gather type: :digits, timeout: 10, number: 1
    after do |response|
      # TODO now this evaluates at the wrong time
      prev_fav = response.phone_call.responses.completed.find_by(prompt_handle: "favourite_number")
      if prev_fav.digits == response.digits
        prompt :second_favourite_number
        message "Sorry, but your second favourite number cannot be the same as your first."
      else
        prompt :favourite_number_reason
        message { |response| "Your favourite numbers have been recorded. The numbers #{response.digits} and #{prev_fav.digits}" }
      end
    end
  end

  prompt :favourite_number_reason do
    message { |response| "Now, please state after the tone your reason for picking those numbers as your favourites." }
    gather type: :voice, length: 4, transcribe: true
    after do
      message "Thank you for your input! We have made a note of your reasons. Your opinion is important to us and will be disregarded.
        Mandate Industries appreciates your business.",
      hangup
    end
  end
end
