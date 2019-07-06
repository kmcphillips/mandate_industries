# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::BaseTree, type: :model do
  let(:described_subclass) do
    Class.new(described_class) do
      class << self
        def tree_name
          "described_subclass"
        end
      end
    end
  end

  describe ".tree" do
    it "is a tree with the name" do
      expect(described_subclass.tree).to be_a(Twilio::Phone::Tree)
      expect(described_subclass.tree.name).to eq("described_subclass")
    end
  end

  describe ".tree_name" do
    it "is the demodulized string" do
      expect(described_class.tree_name).to eq("base")
    end
  end

  context "with FavouriteNumberTree" do
    let(:tree) { Twilio::Phone::Tree.for(:favourite_number) }

    it "sets the name" do
      expect(tree.name).to eq("favourite_number")
    end

    it "sets the configuraton" do
      expect(tree.config[:voice]).to eq("male")
      expect(tree.config[:timeout_message].call(nil)).to eq("We did not receive your response in time.")
    end

    it "sets the greeting" do
      expect(tree.greeting).to be_a(Twilio::Phone::Tree::After)
      expect(tree.greeting.prompt).to eq(:favourite_number)
    end

    it "sets the prompts" do
      expect(tree.prompts.keys).to eq(["favourite_number", "second_favourite_number", "favourite_number_reason"])
      expect(tree.prompts.values).to all(be_a(Twilio::Phone::Tree::Prompt))
    end

    it "loads a gather prompt" do
      prompt = tree.prompts[:second_favourite_number]

      expect(prompt.message).to eq("In the case that your favourite number is not available, please enter your second favourite number.")
      expect(prompt.gather.type).to eq(:digits)
      expect(prompt.gather.args).to eq({ "number" => 1, "timeout" => 10 })
      expect(prompt.after.proc).to be_present
    end

    it "loads a record prompt" do
      prompt = tree.prompts[:favourite_number_reason]

      expect(prompt.message.call(nil)).to eq("Now, please state after the tone your reason for picking those numbers as your favourites.")
      expect(prompt.gather.type).to eq(:voice)
      expect(prompt.gather.args).to eq({ "beep" => true, "length" => 4, "profanity_filter" => false, "transcribe" => true })
      expect(prompt.after.hangup?).to be(true)
      expect(prompt.after.message).to start_with("Thank you for your input!")
    end
  end
end
