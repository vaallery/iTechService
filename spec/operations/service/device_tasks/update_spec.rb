require 'rails_helper'

RSpec.describe Service::DeviceTasks::Update do
  subject(:operation) { described_class.new(notify: stub_notify) }

  let(:stub_notify) { -> {} }
  let(:user) { create :user }
  let(:device_task) { create :device_task }
  let(:repair_service) { create :repair_service }
  let(:store) { create :store }
  let(:repair_part) { create :repair_part }
  let(:contractor) { create :contractor }


  let(:params) { {
    device_task: {
      repair_tasks_attributes: {
        '0': {
          repair_service_id: repair_service.id,
          store_id: store.id,
          price: 1000,
          repair_parts_attributes: {
            '0': {
              item_id: repair_part.item_id,
              quantity: 1,
              warranty_term: 3,
              spare_part_defects_attributes: {
                '0': {
                  qty: 1,
                  contractor_id: contractor.id
                }
              }
            }
          }
        }
      }
    }
  } }

  xit 'should work' do
    result = operation.with_step_args(validate: [device_task], save: [user]).(params)
    expect(result).to be_success
  end
end
