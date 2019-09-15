module ContractorsHelper
  def contractor_options
    options_from_collection_for_select(Contractor.all, :id, :name)
  end
end
