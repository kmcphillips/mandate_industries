# frozen_string_literal: true
class Twilio::Phone::StorytimeTree < Twilio::Phone::BaseTree
  greeting message: ->(response) { "Hello." },
    prompt: :tell_a_story

  prompt :tell_a_story,
    message: "Please tell a story, and press pound when finished.",
    gather: {
      type: :voice,
      length: 45,
      transcribe: true,
    },
    after: {
      hangup: true,
      message: "Thank you.",
    }
end
