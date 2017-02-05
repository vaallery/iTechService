class SalaryReport < BaseReport

  def call
    result[:salary] = []
    users = User.active
    users.find_each do |user|
      user_salaries = []
      user_prepayments = []
      user_installments = []
      5.downto(0) do |n|
        date = n.months.ago
        period = date.beginning_of_month..date.end_of_month
        user_prepayment_details = []
        user_installment_details = []
        user_month_salaries = user.salaries.salary.issued_at period
        user_month_prepayments = user.salaries.prepayment.issued_at period
        user_month_installments = user.installments.paid_at period
        user_month_installment_plans = user.installment_plans.issued_at period

        user_salaries << { amount: user_month_salaries.sum(:amount) }

        user_month_prepayments.each do |prepayment|
          user_prepayment_details << { amount: prepayment.amount, date: prepayment.issued_at, comment: prepayment.comment }
        end
        user_prepayments << { amount: user_month_prepayments.sum(:amount), details: user_prepayment_details }

        user_month_installment_plans.find_each do |installment_plan|
          user_installment_details << { value: installment_plan.cost, date: installment_plan.issued_at, object: installment_plan.object }
        end
        user_month_installments.find_each do |installment|
          user_installment_details << { value: - installment.value, date: installment.paid_at, object: installment.object }
        end
        user_installments << { sum: user_month_installment_plans.sum(:cost) - user_month_installments.sum(:value), details: user_installment_details }

      end
      result[:salary] << { user_name: user.short_name, user_id: user.id, salaries: user_salaries, prepayments: user_prepayments, installments: user_installments }
    end
    result
  end
end