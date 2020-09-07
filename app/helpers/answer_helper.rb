module AnswerHelper
  include TextFormatHelper

  def format_answer(answer)
    case answer
    when Date
      answer = answer.to_formatted_s(:govuk_date)
    when Time
      time_zone = @wizard.export_data["time_zone"] || "London" # rubocop:disable Rails/HelperInstanceVariable
      answer = answer.in_time_zone(time_zone).to_formatted_s(:govuk_time)
    end

    safe_format(answer.to_s, wrapper_tag: "span")
  end
end