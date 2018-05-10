module Service
  class FreeTasksController < ApplicationController
    respond_to :html

    def index
      run FreeTask::Index do
        return render_cell FreeTask::Cell::Index
      end
      failed
    end

    def new
      run FreeTask::Create::Present do
        return render_form
      end
      failed
    end

    def create
      run FreeTask::Create do
        return redirect_to_index
      end
      flash.alert = operation_message
      render_form
    end

    def edit
      run FreeTask::Update::Present do
        return render_form
      end
      failed
    end

    def update
      run FreeTask::Update do
        return redirect_to_index
      end
      render_form
    end

    def destroy
      run FreeTask::Destroy do
        return redirect_to_index notice: operation_message
      end
      failed
    end

    private

    def render_form
      render_cell FreeTask::Cell::Form
    end
  end
end
