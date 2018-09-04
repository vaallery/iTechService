module Service
  class RepairReturnsController < ApplicationController
    include OperationRunner
    respond_to :html

    def index
      authorize RepairReturn
      repair_returns = RepairReturn.query(action_params)

      respond_to do |format|
        content = cell(RepairReturn::Cell::Index, repair_returns).call
        format.html { return render(html: content, layout: true) }
        format.js { return render('index', locals: {content: content}) }
      end
    end

    def new
      run RepairReturn::Build do |r|
        r.success { |repair_return| render_cell(RepairReturn::Cell::Form, model: repair_return) }
        r.failure { |error| failed error }
      end
    end

    def create
      run RepairReturn::Create do |r|
        r.success { |_repair_return| redirect_to root_path, notice: t('service.repair_return.created') }
        r.failure { |errors| failed errors.join('. ') }
      end
    end
  end
end
