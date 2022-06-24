module TeacherTrainingAdviser::Steps
  class StartTeacherTraining < DFEWizard::Step
    attribute :initial_teacher_training_year_id, :integer

    validates :initial_teacher_training_year_id, inclusion: { in: :year_ids }

    NOT_SURE_ID = 12_917

    def reviewable_answers
      super.tap do |answers|
        answers["initial_teacher_training_year_id"] = years.find { |y| y.id == initial_teacher_training_year_id }&.value
      end
    end

    def years
      items = GetIntoTeachingApiClient::PickListItemsApi.new.get_candidate_initial_teacher_training_years

      filter_items(items).map do |item|
        item.value = formatted_value(item)
        item
      end
    end

    def year_ids
      years.map(&:id)
    end

    def skipped?
      other_step(:returning_teacher).returning_to_teaching
    end

  private

    def formatted_value(item)
      return item.value if item.id == NOT_SURE_ID

      year = item.value.to_i

      if year == current_year
        "#{year} - start your training this September"
      else
        year.to_s
      end
    end

    def filter_items(items)
      items.select do |item|
        item.id == NOT_SURE_ID ||
          item.value.to_i.between?(first_year, first_year + number_of_years)
      end
    end

    def first_year
      # After 6th September you can no longer start teacher training for that year.
      include_current_year = Time.zone.today < date_to_drop_current_year
      include_current_year ? current_year : current_year + 1
    end

    def number_of_years
      Time.zone.today.between?(date_to_add_additional_year, date_to_drop_current_year - 1.day) ? 3 : 2
    end

    def date_to_add_additional_year
      Date.new(current_year, 6, 24)
    end

    def date_to_drop_current_year
      Date.new(current_year, 9, 7)
    end

    def current_year
      Time.zone.today.year
    end
  end
end
