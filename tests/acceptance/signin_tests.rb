require_relative './environment.rb'

describe 'signin' do
  include Capybara::DSL

  def fill_in_valid
    @site = Fabricate.attributes_for :site
    fill_in 'username', with: @site[:username]
    fill_in 'password', with: @site[:password]
  end

  def fill_in_valid_signup
    fill_in_valid
    fill_in 'email', with: @site[:email]
  end

  before do
    Capybara.reset_sessions!
  end

  it 'fails for invalid login' do
    visit '/'
    click_link 'Sign In'
    page.must_have_content 'Welcome Back'
    fill_in_valid
    click_button 'Sign In'
    page.must_have_content 'Invalid login'
  end

  it 'fails for missing login' do
    visit '/'
    click_link 'Sign In'
    auth = {username: SecureRandom.hex, password: Faker::Internet.password}
    fill_in 'username', with: auth[:username]
    fill_in 'password', with: auth[:password]
    click_button 'Sign In'
    page.must_have_content 'Invalid login'
  end

  it 'logs in with proper credentials' do
    visit '/'
    click_button 'Create My Website'
    fill_in_valid_signup
    click_button 'Create Home Page'
    Capybara.reset_sessions!
    visit '/'
    click_link 'Sign In'
    fill_in 'username', with: @site[:username]
    fill_in 'password', with: @site[:password]
    click_button 'Sign In'
    page.must_have_content 'Your Feed'
  end
end