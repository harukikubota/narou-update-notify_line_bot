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

## novel sample
Novel.build_by_ncode('n2267be')

## writer sample
Writer.build_by_writer_id('235132')

## recommend
ncodes = %w[n6169dz n9016cm n2267be n6161h n1488bj]
Recommend.build_recommend_by_ncodes(ncodes)
