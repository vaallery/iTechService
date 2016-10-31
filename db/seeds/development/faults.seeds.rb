after 'development:fault_kinds' do

  User.staff.active.each do |user|
    unless Fault.exists?(causer: user)
      FaultKind.all.each do |fault_kind|
        rand(5).times do
          Fault.create! causer: user, kind: fault_kind, date: rand(60).days.ago, comment: Faker::Lorem.sentence
        end
      end
    end
  end
end