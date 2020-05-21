module AcceptanceTestHelper

  def user_login_as(user)
    # visit root_path
    # # within '#sign-in-form' do
    # fill_in 'user[email]', with: user.email
    # fill_in 'user[password]', with: ENV['PSWD']
    # click_button I18n.t('helpers.buttons.sign_in', default: 'Sign in')
    # end
  end

  def admin_login_as(admin)
    # visit new_admin_session_path
    # # within '#sign-in-form' do
    # fill_in 'admin[email]', with: admin.email
    # fill_in 'admin[password]', with: ENV['PSWD']
    # click_button I18n.t('helpers.buttons.sign_in', default: 'Sign in')
    # # end
  end

  def page!
    save_and_open_page
  end

  def screenshot!
    # save_and_open_screenshot
    save_screenshot "~/Desktop/screenshot_#{Time.current}.png", full: true
  end

  def enable_js
    Capybara.current_driver = Capybara.javascript_driver
  end

  def disable_js
    Capybara.current_driver = Capybara.default_driver
  end
end