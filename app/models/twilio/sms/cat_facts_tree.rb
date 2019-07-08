# frozen_string_literal: true
class Twilio::SMS::CatFactsTree < Twilio::SMS::BaseTree
  greeting :hello

  say :hello,
    message: "Hello, and thank you for subscribing to \"Cat Facts\"!",
    after: :first_fact

  say :first_fact,
    message: "Did you know X?"
    after: :first_unsubscribe

  ask :first_unsubscribe,
    message: "Do you want to unsubscribe? Reply with YES or NO.",
    after: ->(message) {
      if message.body.downcase =~ /yes/
        :are_you_sure
      elsif message.body.downcase =~ /no/
        :stay_subscribed
      else
        :assuming_subscribed
      end
    }

  say :assuming_subscribed,
    message: "We did not understand your response, so assuming YES.",
    after: :second_fact

  say :stay_subscribed,
    message: "Thank you for your subscription!",
    after: :second_fact

  ask :are_you_sure,
    message: "Sad to hear that. But how about one more chance?",
    after: ->(message) {
      # TODO
    }
end
