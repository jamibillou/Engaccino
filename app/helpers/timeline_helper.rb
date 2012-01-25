module TimelineHelper
  
  def design_block(object, collection, horizontal_unit, vertical_unit)
    { :height  => (object.duration * vertical_unit).round,
      :width   => (object.duration * horizontal_unit).round(1),
      :left    => (object.yrs_after_first_event * horizontal_unit).round(1),
      :z_index => (1000 / object.duration).round,
      :shade   => (object.duration * 0.4 / object.candidate.longest(collection).duration).round(2),
      :label   => { :height    => ((object.candidate.longest_event.duration * 1.7 - object.duration) * vertical_unit).round,
                    :left      => ((object.yrs_after_first_event + object.duration / 2) * horizontal_unit).round(1),
                    :vertical? => object.duration < object.candidate.timeline_duration / 5 }}
  end
  
  def design_axis(candidate, horizontal_unit, vertical_unit)
    { :width                      => (candidate.timeline_duration * horizontal_unit).round(1),
      :first_unit_mark            => ((13 - candidate.first_event.start_month) * horizontal_unit / 12).round(1),
      :big_first_unit_mark        => candidate.first_event.start_month <= 6,
      :unit_mark                  => horizontal_unit.round(1),
      :first_decade_unit_mark     => (((13 - candidate.first_event.start_month) / 12 + (10 - candidate.first_event.start_year.modulo(10))) * horizontal_unit ).round(1),
      :big_first_decade_unit_mark => candidate.first_event.start_year - decade(candidate.first_event.start_year) <= 5,
      :decade_unit_mark           => horizontal_unit.round(2) * 10 }
  end
  
  def ten_yrs_bracket(year)
    "#{decade(year)} - #{decade(year) + 10}"
  end
  
  def decade(year)
    (year / 10).truncate * 10
  end
  
end