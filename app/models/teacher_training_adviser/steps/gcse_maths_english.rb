module TeacherTrainingAdviser::Steps
  class GcseMathsEnglish < Wizard::Step
    attribute :has_gcse_maths_and_english_id, :integer

    validates :has_gcse_maths_and_english_id, types: { method: :get_candidate_retake_gcse_status, message: "You must select either yes or no" }

    OPTIONS = Crm::OPTIONS

    def skipped?
      @store["returning_to_teaching"] ||
        [
          TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:studying],
          TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:degree],
        ].none?(@store["degree_options"])
    end
  end
end