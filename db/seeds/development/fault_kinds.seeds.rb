10.times do |n|
  FaultKind.where(name: "#{FaultKind.model_name.human} #{n}").first_or_create!(is_permanent: n.odd?)
end