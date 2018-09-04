require 'rails_helper'

RSpec.feature "Returning repair" do
  scenario "User returns repair" do
    visit '/service/repair_returns/new'

    fill_in 'ticket_number', with: service_job.ticket_number
    click_button 'find_job'

    expect(page).to have_text(service_job.serial_number)
    expect(page).to have_text(service_job.repair_parts.first.name)

    click_button 'return'

    expect(page).to have_text('Repair returned')
  end
end
