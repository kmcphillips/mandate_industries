# frozen_string_literal: true
class Twilio::Phone::ToneRatingTree < Twilio::Phone::BaseTree
  voice "female"

  greeting message: "Hello. Please listen to the following tone:",
    prompt: :play_first_tone

  prompt :play_first_tone,
    play: ->(response) { "https://www.mediacollege.com/audio/tone/files/440Hz_44100Hz_16bit_05sec.wav" }, # TODO host this
    after: {
      prompt: :first_tone_feedback,
      message: "Thank you for listening to that tone.",
    }

  prompt :first_tone_feedback,
    message: "On a scale from zero to six, please rate how much you enjoyed this tone",
    gather: {
      type: :digits,
      timeout: 10,
      number: 1,
    },
    after: ->(response) {
      if response.digits.present? && response.digits.to_i <= 6
        {
          hangup: true,
          message: "Thank you for your rating of #{response.digits} for this tone. Your feedback is important. Goodbye.",
        }
      else
        {
          prompt: :first_tone_feedback,
          message: "Sorry, you have entered an invalid rating of #{response.digits}",
        }
      end
    }
end
