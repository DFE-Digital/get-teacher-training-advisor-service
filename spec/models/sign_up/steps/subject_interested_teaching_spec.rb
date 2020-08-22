require "rails_helper"

RSpec.describe SignUp::Steps::SubjectInterestedTeaching do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  it_behaves_like "a wizard step that exposes API types as options", :get_teaching_subjects

  context "attributes" do
    it { is_expected.to respond_to :preferred_teaching_subject_id }
  end

  describe "#preferred_teaching_subject_id" do
    it "allows a valid preferred_teaching_subject_id" do
      subject_type = GetIntoTeachingApiClient::TypeEntity.new(id: "abc-123")
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_teaching_subjects) { [subject_type] }
      expect(subject).to allow_value(subject_type.id).for :preferred_teaching_subject_id
    end

    it { is_expected.to_not allow_values("", nil).for :preferred_teaching_subject_id }
  end

  describe "#skipped?" do
    it "returns false if returning_to_teaching is false and degree_options is equivalent and preferred_education_phase_id is secondary" do
      wizardstore["returning_to_teaching"] = false
      wizardstore["degree_options"] = HaveADegree::DEGREE_OPTIONS[:equivalent]
      wizardstore["preferred_education_phase_id"] = StageInterestedTeaching::OPTIONS[:secondary]
      expect(subject).to_not be_skipped
    end

    it "returns true if degree_options is not equivalent" do
      wizardstore["returning_to_teaching"] = false
      wizardstore["degree_options"] = HaveADegree::DEGREE_OPTIONS[:degree]
      wizardstore["preferred_education_phase_id"] = StageInterestedTeaching::OPTIONS[:secondary]
      expect(subject).to be_skipped
    end

    it "returns true if preferred_education_phase_id is not secondary" do
      wizardstore["returning_to_teaching"] = false
      wizardstore["degree_options"] = HaveADegree::DEGREE_OPTIONS[:equivalent]
      wizardstore["preferred_education_phase_id"] = StageInterestedTeaching::OPTIONS[:primary]
      expect(subject).to be_skipped
    end

    it "returns true if returning_to_teaching is not false" do
      wizardstore["returning_to_teaching"] = true
      wizardstore["degree_options"] = HaveADegree::DEGREE_OPTIONS[:equivalent]
      wizardstore["preferred_education_phase_id"] = StageInterestedTeaching::OPTIONS[:secondary]
      expect(subject).to be_skipped
    end
  end
end
