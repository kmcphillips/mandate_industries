# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::Phone::Tree, type: :model do
  let(:tree) { double }

  describe ".for" do
    it "loads the class by name" do
      expect(described_class.for("favourite_number")).to be_a(Twilio::Phone::Tree)
      expect(described_class.for("favourite_number").name).to eq("favourite_number")
    end

    it "raises if not found" do
      expect { described_class.for("abc") }.to raise_error(NameError)
    end
  end

  describe "#initialize" do
    let(:tree) { described_class.new(:example) }

    it "sets a config with defaults" do
      expect(tree.config).to eq("voice" => "male")
    end
  end

  describe Twilio::Phone::Tree::Prompt, type: :model do
    describe "#initialize" do
      let(:valid_attributes) { { name: "asdf", message: "hello", gather: { type: :digits }, after: :hangup } }

      it "sets the gather" do
        expect(described_class.new(valid_attributes).gather).to be_a(Twilio::Phone::Tree::Gather)
      end

      it "sets the after" do
        expect(described_class.new(valid_attributes).after).to be_a(Twilio::Phone::Tree::After)
      end

      it "sets the message" do
        expect(described_class.new(valid_attributes).message).to eq("hello")
      end

      it "raises if message is something weird" do
        expect { described_class.new(valid_attributes.merge(message: Object.new)) }.to raise_error(Twilio::Phone::Tree::InvalidError)
      end

      it "sets the prompt name" do
        expect(described_class.new(valid_attributes).name).to eq(:asdf)
      end

      it "raises if prompt name is not set" do
        expect { described_class.new(valid_attributes.merge(name: nil)) }.to raise_error(Twilio::Phone::Tree::InvalidError)
      end
    end
  end

  describe Twilio::Phone::Tree::After, type: :model do
    describe "#initialize" do
      context "accepts a hash" do
        it "with a prompt as string" do
          expect(described_class.new("prompt" => "abc").prompt).to eq(:abc)
        end

        it "with a prompt as symbol" do
          expect(described_class.new(prompt: :abc).prompt).to eq(:abc)
        end

        it "with hangup" do
          expect(described_class.new(hangup: true).hangup?).to be true
        end

        it "with hangup as something" do
          expect(described_class.new("hangup" => "yes").hangup?).to be true
        end

        it "with hangup as something" do
          expect(described_class.new(prompt: :abc).hangup?).to be false
        end

        it "raises without prompt or hangup" do
          expect { described_class.new({}) }.to raise_error(Twilio::Phone::Tree::InvalidError)
        end

        it "raises with prompt and hangup" do
          expect { described_class.new(prompt: :abc, hangup: true) }.to raise_error(Twilio::Phone::Tree::InvalidError)
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
        expect { described_class.new(nil) }.to raise_error(Twilio::Phone::Tree::InvalidError)
      end
    end
  end

  describe Twilio::Phone::Tree::Gather, type: :model do
    describe "#initialize" do
      context "accepts a hash" do
        it "with a type as string" do
          expect(described_class.new("type" => "digits").type).to eq(:digits)
        end

        it "with a type as symbol" do
          expect(described_class.new(type: :digits).type).to eq(:digits)
        end

        it "sets digits? accessor" do
          expect(described_class.new(type: :digits).digits?).to be true
          expect(described_class.new(type: :digits).voice?).to be false
        end

        it "sets voice? accessor" do
          expect(described_class.new(type: :voice).digits?).to be false
          expect(described_class.new(type: :voice).voice?).to be true
        end

        it "and raises with invalid type" do
          expect { described_class.new(type: :asdf) }.to raise_error(Twilio::Phone::Tree::InvalidError)
        end
      end

      it "does not accept a string" do
        expect { described_class.new("whatever") }.to raise_error(Twilio::Phone::Tree::InvalidError)
      end

      it "does not accept a symbol" do
        expect { described_class.new(:asdf) }.to raise_error(Twilio::Phone::Tree::InvalidError)
      end

      it "does not accept nil" do
        expect { described_class.new(nil) }.to raise_error(Twilio::Phone::Tree::InvalidError)
      end
    end
  end
end

