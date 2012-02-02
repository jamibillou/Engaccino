module TimelineHelper
  
  def design_block(object, collection, units)
    duration = object.duration ; width = (duration * units[:x]).round(2)
    { :height  => (duration * units[:y]).round,
      :width   => width,
      :left    => (object.yrs_after_first_event * units[:x]).round(2),
      :z_index => duration.round != 0 ? (1000 / duration).round : 1000,
      :shade   => (duration * 0.4 / object.candidate.longest(collection).duration).round(2),
      :label   => { :left => ((object.yrs_after_first_event + duration / 2) * units[:x]).round(2),
                    :type => if width < 10 then 'vertical' elsif width < 12.5 then 'mini' elsif width < 15 then 'small' elsif width < 25 then 'average' else 'big' end,
                    :text => object.class == Education ? object.degree.label : object.role } }
  end
  
  def design_axis(candidate, units)
    { :width            => (candidate.timeline_duration * units[:x]).round(2),
      :unit_marks       => candidate.last_event.end_year - candidate.first_event.start_year - 1,
      :unit_mark        => units[:x].round(2),
      :first_unit_mark  => ((13 - candidate.first_event.start_month) * units[:x] / 12).round(2),
      :last_unit_mark   => (candidate.last_event.end_month * units[:x] / 12).round(2) }
  end
  
  def design_axis_w_decades(candidate, units)
    { :width            => (candidate.timeline_duration * units[:x]).round(2),
      :unit_marks       => (decade(candidate.last_event.end_year) - decade(candidate.first_event.start_year) - 10) / 10,
      :unit_mark        => units[:x].round(3) * 10,
      :first_unit_mark  => (((13 - candidate.first_event.start_month) / 12 + (10 - candidate.first_event.start_year.modulo(10))) * units[:x] ).round(2),
      :last_unit_mark   => (((13 - candidate.last_event.end_month) / 12 + candidate.last_event.end_year.modulo(10)) * units[:x] ).round(2) }
  end
  
  def first_unit_mark?(candidate)
    candidate.long_timeline? ? candidate.first_event.start_year - decade(candidate.first_event.start_year) <= 5 : candidate.first_event.start_month <= 6
  end
  
  def last_unit_mark?(candidate)
    candidate.long_timeline? ? candidate.last_event.end_year - decade(candidate.last_event.end_year) >= 5 : candidate.last_event.end_month >= 6
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