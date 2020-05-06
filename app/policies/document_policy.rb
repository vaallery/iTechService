class DocumentPolicy < ApplicationPolicy
  def manage?
    any_manager?
  end

  def show?
    read?
  end

  def create?; manage?; end

  def update?
    editable? && manage?
  end

  def destroy?
    destroyable? && manage?
  end

  def post?
    postable? && manage?
  end

  def unpost?
    unpostable? && manage?
  end

  private

  def editable?
    record.is_new?
  end

  def destroyable?
    record.is_new? || record.is_deleted?
  end

  def postable?
    record.is_new?
  end

  def unpostable?
    record.is_posted?
  end
end
