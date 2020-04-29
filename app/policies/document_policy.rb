class DocumentPolicy < BasePolicy
  def index?
    any_manager?
  end

  def show?
    same_department? && any_manager?
  end

  def create?; any_manager?; end

  def update?
    editable? && same_department? && any_manager?
  end

  def destroy?
    destroyable? && same_department? && any_manager?
  end

  def post?
    postable? && same_department? && any_manager?
  end

  def unpost?
    unpostable? && same_department? && any_manager?
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
