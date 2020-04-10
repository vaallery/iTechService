module Service
  class JobTemplatesController < ApplicationController
    skip_after_action :verify_authorized
    respond_to :html

    def index
      respond_to do |format|
        run JobTemplate::Index do
          format.html { return render_cell(JobTemplate::Cell::Index) }
        end
        format.html { failed }
      end
    end

    def new
      run JobTemplate::Create::Present do
        return render_form
      end
      failed
    end

    def create
      run JobTemplate::Create do
        return redirect_to_index
      end
      flash.alert = operation_message
      render_form
    end

    def edit
      run JobTemplate::Update::Present do
        return render_form
      end
      failed
    end

    def update
      run JobTemplate::Update do
        return redirect_to_index
      end
      render_form
    end

    def destroy
      run JobTemplate::Destroy do
        return redirect_to_index notice: operation_message
      end
      failed
    end

    private

    def render_form
      render_cell JobTemplate::Cell::Form
    end
  end
end
