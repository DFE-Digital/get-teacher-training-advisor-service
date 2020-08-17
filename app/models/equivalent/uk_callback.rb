module Equivalent
  class UkCallback < Callback
    class << self
      def options
        quotas = ApiClient.get_callback_booking_quotas
        grouped_quotas = quotas.group_by(&:day)
        options_hash = Hash.new { |hash, key| hash[key] = [] }
        grouped_quotas.each do |day, data|
          data.each do |x|
            options_hash[day] << [x.time_slot, x.start_at]
          end
        end
        next_day_check(options_hash)
      end
    end

    def next_step
      "equivalent/uk_completion"
    end
  end
end
