# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::SMS::Tree, type: :model do
  let(:tree) { double }

  describe ".for" do
    it "loads the class by name" do
      expect(described_class.for("cat_facts")).to be_a(Twilio::SMS::Tree)
      expect(described_class.for("cat_facts").name).to eq("cat_facts")
    end

    it "raises if not found" do
      expect { described_class.for("abc") }.to raise_error(NameError)
    end
  end

  describe "#initialize" do
    let(:tree) { described_class.new(:example) }

    it "sets a config with defaults" do
      expect(tree.config).to eq({})
    end
  end

  describe Twilio::SMS::Tree::Prompt, type: :model do
    describe "#initialize" do
      let(:valid_attributes) { { name: "asdf", message: "hello", after: { message: "and next", prompt: :next_prompt } } }

      it "sets the after" do
        expect(described_class.new(valid_attributes).after).to be_a(Twilio::SMS::Tree::After)
      end

      it "sets the message" do
        expect(described_class.new(valid_attributes).message).to eq("hello")
      end

      it "raises if message is something weird" do
        expect { described_class.new(valid_attributes.merge(message: Object.new)) }.to raise_error(Twilio::InvalidTreeError)
      end

      it "sets the prompt name" do
        expect(described_class.new(valid_attributes).name).to eq(:asdf)
      end

      it "raises if prompt name is not set" do
        expect { described_class.new(valid_attributes.merge(name: nil)) }.to raise_error(Twilio::InvalidTreeError)
      end
    end
  end

  describe Twilio::SMS::Tree::After, type: :model do
    describe "#initialize" do
      context "accepts a hash" do
        it "with a prompt as string" do
          expect(described_class.new("prompt" => "abc").prompt).to eq(:abc)
        end

        it "with a prompt as symbol" do
          expect(described_class.new(prompt: :abc).prompt).to eq(:abc)
        end

        it "sets the message" do
          expect(described_class.new(message: "hello", prompt: :asdf).message).to eq("hello")
        end
      end

      it "accepts a string" do
        expect(described_class.new(:abc).prompt).to eq(:abc)
      end

      it "accepts a symbol" do
        expect(described_class.new("abc").prompt).to eq(:abc)
      end

      it "does not accept nil" do
        expect { described_class.new(nil) }.to raise_error(Twilio::InvalidTreeError)
      end
    end
  end
end

