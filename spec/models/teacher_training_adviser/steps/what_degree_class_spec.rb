require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::WhatDegreeClass do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  it_behaves_like "a wizard step that exposes API types as options", :get_qualification_uk_degree_grades

  context "attributes" do
    it { is_expected.to respond_to :uk_degree_grade_id }
  end

  describe "#uk_degree_grade_id" do
    it "allows a valid uk_degree_grade_id" do
      grade = GetIntoTeachingApiClient::TypeEntity.new(id: TeacherTrainingAdviser::Steps::WhatDegreeClass.options["Not applicable"])
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_qualification_uk_degree_grades) { [grade] }
      expect(subject).to allow_value(grade.id).for :uk_degree_grade_id
    end

    it { is_expected.to_not allow_values("", nil, 456).for :uk_degree_grade_id }
  end

  describe "#skipped?" do
    it "returns false if degree_options is studying/degree" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying]
      expect(subject).to_not be_skipped
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:degree]
      expect(subject).to_not be_skipped
    end

    it "returns true if degree_options is not studying/degree" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      expect(subject).to be_skipped
    end

    it "returns true if returning_to_teaching is true" do
      wizardstore["returning_to_teaching"] = true
      expect(subject).to be_skipped
    end
  end

  describe "#studying?" do
    it "returns true if degree_options is studying" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying]
      expect(subject).to be_studying
    end

    it "returns false if degree_options is not studying" do
      wizardstore["degree_options"] = TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:degree]
      expect(subject).to_not be_studying
    end
  end

  describe "#self.options" do
    it "returns a hash of filtered options" do
      expect(TeacherTrainingAdviser::Steps::WhatDegreeClass.options).to eq({ "Not applicable" => "222750000", "First class" => "222750001", "2:1" => "222750002", "2:2" => "222750003" })
    end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }
    let(:type) { GetIntoTeachingApiClient::TypeEntity.new(id: 123, value: "Value") }
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_qualification_uk_degree_grades) { [type] }
      instance.uk_degree_grade_id = type.id
    end

    it { is_expected.to eq({ "uk_degree_grade_id" => "Value" }) }
  end
end
