class DocumentPolicy < ApplicationPolicy
  def manage?
    any_manager?
  end

  def show?
    read?
  end

  def create?; modify?; end

  def update?
    editable? && modify?
  end

  def destroy?
    destroyable? && manage?
  end

  def post?
    postable? && modify?
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
