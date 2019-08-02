class UserConfig < ApplicationRecord

  has_one :user
  has_one :config_notify_time
  has_one :config_separate

  DEFAULT_TIMES = %w[7 23].map(&:to_i).map(&:freeze).freeze
  DEFAULT_SEP = '-'.freeze

  class << self
    def default_record
      def_time_id, def_sep_id = find_default_configs_id

      new(
        user_id: nil,
        config_notify_time_id: def_time_id,
        config_separate_id: def_sep_id
      )
    end

    private

    def find_default_configs_id
      def_time = ConfigNotifyTime.where(
        time_range_start: DEFAULT_TIMES[0],
        time_range_end: DEFAULT_TIMES[1]
      ).first
      def_sep = ConfigSeparate.find_by_use_str(DEFAULT_SEP)

      [def_time.id, def_sep.id]
    end
  end

  def change_notify_time(config_notify_time_id)
    update(config_notify_time_id: config_notify_time_id)
  end
end
