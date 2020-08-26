RSpec.shared_context "wizard store" do
  let(:backingstore) { { "name" => "Joe", "age" => 35 } }
  let(:wizardstore) { Wizard::Store.new backingstore }
end

RSpec.shared_context "wizard step" do
  include_context "wizard store"
  let(:attributes) { {} }
  let(:instance) { described_class.new nil, wizardstore, attributes }
  subject { instance }
end

RSpec.shared_examples "a wizard step" do
  it { expect(subject.class).to respond_to :key }
  it { is_expected.to respond_to :save }
end

RSpec.shared_examples "a wizard step that exposes API types as options" do |api_method|
  it { expect(subject.class).to respond_to :options }

  it "it exposes API types as options" do
    types = [
      GetIntoTeachingApiClient::TypeEntity.new(id: 1, value: "one"),
      GetIntoTeachingApiClient::TypeEntity.new(id: 2, value: "two"),
    ]

    allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
      receive(api_method) { types }

    expect(described_class.options).to eq({ "one" => 1, "two" => 2 })
  end
end

class TestWizard < Wizard::Base
  class Name < Wizard::Step
    attribute :name
    validates :name, presence: true
  end

  class Age < Wizard::Step
    attribute :age, :integer
    validates :age, presence: true
  end

  class Postcode < Wizard::Step
    attribute :postcode
    validates :postcode, presence: true
  end

  self.steps = [Name, Age, Postcode].freeze
end