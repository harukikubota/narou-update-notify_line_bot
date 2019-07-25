## config_notify_time
notify_time_starts = %w[0 7].map(&:to_i)
notify_time_ends = %w[24 23].map(&:to_i)
notify_time_starts.zip(notify_time_ends).each do |start_t, end_t|
  ConfigNotifyTime.create(
    time_range_start: start_t,
    time_range_end: end_t
  )
end

## config_separate
use_separators = %w[- ~ # ☆]
use_separators.each do |sep|
  ConfigSeparate.create(
    use_str: sep
  )
end

## user_config
### default value.
default_user_config = UserConfig.default_record

needs_updating_users = User.where(user_config_id: nil)
needs_updating_users.each do |user|
  default_user_config.user_id = user.id
  default_user_config.save
  user.update(user_config_id: default_user_config.id)
end
## novel
Novel.build_by_ncode('n2267be')

## writer
Writer.build_by_writer_id('235132')
