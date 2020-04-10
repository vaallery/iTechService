class OrderNotesController < ApplicationController
  def create
    authorize OrderNote
    order = policy_scope(Order).find(params[:order_id])
    order_note = order.notes.build(params[:order_note])
    order_note.author = current_user

    respond_to do |format|
      if order_note.save
        format.js { render 'create', locals: {order_note: order_note} }
      else
        format.js { render_error order_note.errors.full_messages.join('. ') }
      end
    end
  end
end
