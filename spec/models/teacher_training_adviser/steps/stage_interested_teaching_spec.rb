require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::StageInterestedTeaching do
  include_context "wizard step"
  it_behaves_like "a wizard step"

  context "attributes" do
    it { is_expected.to respond_to :preferred_education_phase_id }
  end

  describe "#preferred_education_phase_id" do
    it { is_expected.to_not allow_values("", nil, 123).for :preferred_education_phase_id }
    it { is_expected.to allow_value(*TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS.values).for :preferred_education_phase_id }
  end

  describe "#skipped?" do
    it "returns false if returning_to_teaching is false" do
      wizardstore["returning_to_teaching"] = false
      expect(subject).to_not be_skipped
    end

    it "returns true if returning_to_teaching is true" do
      wizardstore["returning_to_teaching"] = true
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }
    before { instance.preferred_education_phase_id = TeacherTrainingAdviser::Steps::StageInterestedTeaching::OPTIONS[:primary] }
    it { is_expected.to eq({ "preferred_education_phase_id" => "Primary" }) }
  end
end
