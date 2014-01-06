module FeatureTypesHelper

  def human_feature_type_kind(arg)
    t "feature_types.kinds.#{arg.is_a?(FeatureType) ? arg.kind : arg}"
  end

  def feature_type_kinds_for_select
    FeatureType::KINDS.map {|kind| [t("feature_types.kinds.#{kind}"), kind]}
  end

end
