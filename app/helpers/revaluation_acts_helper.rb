module RevaluationActsHelper

  def revaluation_act_row_class(revaluation_act)
    case revaluation_act.status
      when 0 then
        'info'
      when 1 then
        'success'
      when 2 then
        'error'
    end
  end

end
