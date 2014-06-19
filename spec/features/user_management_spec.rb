require 'spec_helper'

feature "User signs up" do
	
# tests on both UI and DB shoudl be in different spec sheets in order only to be tesing one things at a time, but for the same of keeping this example simple we don't do that here.

	scenario "when being logged out" do
		lambda { sign_up }.should change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")
		expect(User.first.email).to eq("alice@example.com")
	end

	def sign_up(email = "alice@example.com", password = "oranges!")
		visit '/usrs/new'
		expect(page.status_code).to eq(200)
		expect(page.status_code).to eq(200) #typo surely?
		fill_in :email, :with => email
		fill_in :password, :with => password
		click_button "Sign up"
	end



end