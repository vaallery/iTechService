class BaseOperation < Trailblazer::Operation

  private

  def record_not_found!(options, **)
    options['result.message'] = I18n.t('errors.messages.record_not_found')
    Railway.fail_fast!
  end

  def not_authorized!(options, **)
    options['result.message'] = I18n.t('pundit.default')
    Railway.fail_fast!
  end

  def contract_invalid!(options, **)
    options['result.message'] = I18n.t('errors.messages.contract_invalid')
    Railway.fail_fast!
  end
end