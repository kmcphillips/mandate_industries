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

    it "sets the greeting" do
      expect(tree.greeting).to be_a(Twilio::Phone::Tree::After)
    end

    it "sets the prompts" do
      expect(tree.prompts.keys).to eq(["favourite_number", "second_favourite_number", "favourite_number_reason"])
      expect(tree.prompts.values).to all(be_a(Twilio::Phone::Tree::Prompt))
    end

    it "reasons about the detailed state more"
  end
end
