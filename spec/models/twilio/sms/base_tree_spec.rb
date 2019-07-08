# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Twilio::SMS::BaseTree, type: :model do
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
      expect(described_subclass.tree).to be_a(Twilio::SMS::Tree)
      expect(described_subclass.tree.name).to eq("described_subclass")
    end
  end

  describe ".tree_name" do
    it "is the demodulized string" do
      expect(described_class.tree_name).to eq("base")
    end
  end

  context "with CatFactsTree" do
    let(:tree) { Twilio::SMS::Tree.for(:cat_facts) }

    it "sets the name" do
      expect(tree.name).to eq("cat_facts")
    end

    it "sets the configuraton" do
      expect(tree.config).to eq({})
    end

    it "sets the prompts" do
      skip
      expect(tree.prompts.keys).to eq(["favourite_number", "second_favourite_number", "favourite_number_reason"])
      expect(tree.prompts.values).to all(be_a(Twilio::SMS::Tree::Prompt))
    end
  end
end
