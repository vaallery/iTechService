module StoresHelper

  def store_kinds_for_select
    Store::KINDS.map { |k| [t("stores.kinds.#{k}"), k] }
  end

  def human_store_kind(store)
    store.kind.blank? ? nil : t("stores.kinds.#{store.kind}")
  end

end
