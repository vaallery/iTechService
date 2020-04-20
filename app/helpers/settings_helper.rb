module SettingsHelper
  def settings_options_collection
    Setting::TYPES.keys.map { |name| [I18n.t("settings.#{name}", default: name.to_s.humanize), name] }
  end
end