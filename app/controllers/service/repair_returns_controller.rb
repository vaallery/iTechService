module Service
  class RepairReturnsController < ApplicationController
    include OperationRunner
    respond_to :html

    def index
    end

    def new
      run RepairReturn::Build do |r|
        r.success { |repair_return| render_cell(RepairReturn::Cell::Form, model: repair_return) }
        r.failure { |error| failed error }
      end
    end

    def create
    end
  end
end
