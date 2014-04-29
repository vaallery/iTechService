module DataSyncHelper

  def data_sync_modes_collection
    Sync::DataSyncJob::MODES
  end

  def data_sync_branches_collection
    Department.branches.map{|d|[d.name, d.code]}
  end

  def data_sync_actions_collection
    [[t('data_sync.import'), 'import'], [t('data_sync.export'), 'export'], [t('data_sync.sync'), 'sync']]
  end

  def data_sync_models_collection
    (Sync::DataSyncJob.COMMON_MODELS + Sync::DataSyncJob.IMPORT_MODELS).uniq
  end

end