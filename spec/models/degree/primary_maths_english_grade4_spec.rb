require "rails_helper"

RSpec.describe Degree::PrimaryMathsEnglishGrade4, :vcr do
  subject { build(:degree_primary_maths_english_grade4) }
  let(:no) { build(:degree_primary_maths_english_grade4, has_required_subjects: "222750000") }

  describe "#next_step" do
    context "when answer is true" do
      it "returns the correct option" do
        expect(subject.next_step).to eq("degree/science_grade4")
      end
    end

    context "when answer is false" do
      it "returns the correct option" do
        expect(no.next_step).to eq("degree/primary_retake_english_maths")
      end
    end
  end
end
