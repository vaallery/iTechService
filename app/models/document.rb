module Document

  STATUSES = {
      0 => 'new',
      1 => 'posted',
      2 => 'deleted'
  }

  def status_s
    STATUSES[status]
  end

  def is_new?
    self.status == 0
  end

  def is_posted?
    self.status == 1
  end

  def is_deleted?
    self.status == 2
  end

  def set_deleted
    if self.status == 1
      self.errors.add :status, I18n.t('documents.errors.deleting_posted')
    else
      self.update_attribute :status, 2
    end
  end
end
