class DocumentPolicy < ApplicationPolicy
  def manage?
    any_manager?
  end

  def show?
    read?
  end

  def create?; any_manager?; end

  def update?
    editable? && any_manager?
  end

  def destroy?
    destroyable? && any_manager?
  end

  def post?
    postable? && any_manager?
  end

  def unpost?
    unpostable? && any_manager?
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
