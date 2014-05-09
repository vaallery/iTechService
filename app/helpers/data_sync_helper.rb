module DataSyncHelper

  def data_sync_modes_collection
    Sync::DataSyncJob::MODES
  end

  def data_sync_branches_collection
    Department.branches.map{|d|[d.name, d.code]}
  end

  def data_sync_actions_collection
    Sync::DataSyncJob::ACTIONS.map{|a|[t("data_sync.#{a}"), a]}
  end

  def data_sync_models_collection
    Sync::DataSyncJob::COMMON_MODELS | Sync::DataSyncJob::IMPORT_MODELS
  end

end