module TimelineHelper
  
  def design_block(object, collection, horizontal_unit, vertical_unit)
    { :height  => (object.duration * vertical_unit).round,
      :width   => (object.duration * horizontal_unit).round(2),
      :left    => (object.yrs_after_first_event * horizontal_unit).round(2),
      :z_index => object.duration.round != 0 ? (1000 / object.duration).round : 1000,
      :shade   => (object.duration * 0.4 / object.candidate.longest(collection).duration).round(2),
      :label   => { :left      => ((object.yrs_after_first_event + object.duration / 2) * horizontal_unit).round(2),
                    :vertical? => object.duration < object.candidate.timeline_duration / 5 } }
  end
  
  def design_axis(candidate, horizontal_unit, vertical_unit)
    { :width            => (candidate.timeline_duration * horizontal_unit).round(2),
      :unit_marks       => candidate.timeline_duration.round - 1,
      :unit_mark        => horizontal_unit.round(2),
      :first_unit_mark  => ((13 - candidate.first_event.start_month) * horizontal_unit / 12).round(2),
      :last_unit_mark   => (candidate.last_event.end_month * horizontal_unit / 12).round(2) }
  end
  
  def design_axis_w_decades(candidate, horizontal_unit, vertical_unit)
    { :width            => (candidate.timeline_duration * horizontal_unit).round(2),
      :unit_marks       => (candidate.timeline_duration / 10).round - 1, ### try calculating this from decades of first and last events
      :unit_mark        => horizontal_unit.round(3) * 10,
      :first_unit_mark  => (((13 - candidate.first_event.start_month) / 12 + (10 - candidate.first_event.start_year.modulo(10))) * horizontal_unit ).round(2),
      :last_unit_mark   => (((13 - candidate.last_event.end_month) / 12 + candidate.last_event.end_year.modulo(10)) * horizontal_unit ).round(2) }
  end
  
  def first_unit_mark?(candidate)
    candidate.long_timeline? ? candidate.first_event.start_year - decade(candidate.first_event.start_year) <= 5 : candidate.first_event.start_month <= 6
  end
  
  def last_unit_mark?(candidate)
    if candidate.long_timeline?
      candidate.last_event.end_year - decade(candidate.last_event.end_year) >= 5 ### add case when end_year is the last of the decade (expression == 0)
    else
      candidate.last_event.end_month >= 6 && candidate.first_event.start_year + candidate.timeline_duration.round - 1 < candidate.last_event.end_year
    end
  end
  
  def unit_mark_label(candidate, type, year = '')
    case type
      when :first
        candidate.long_timeline? ? ten_yrs_bracket(candidate.first_event.start_year, :first) : candidate.first_event.start_year
      when :normal
        candidate.long_timeline? ? ten_yrs_bracket(candidate.first_event.start_year + (year + 1) * 10) : candidate.first_event.start_year + year + 1
      when :last
        candidate.long_timeline? ? ten_yrs_bracket(candidate.last_event.end_year, :last) : candidate.last_event.end_year
    end
  end
  
  def ten_yrs_bracket(year, type = '')
    "#{type == :first ? year : decade(year)} - #{type == :last ? year : decade(year) + 10}"
  end
  
  def decade(year)
    (year / 10).truncate * 10
  end
  
end