require 'spec_helper'

feature "User signs up" do
	
# tests on both UI and DB shoudl be in different spec sheets in order only to be tesing one things at a time, but for the same of keeping this example simple we don't do that here.

	scenario "when signing up a user is added to the db" do
		lambda { sign_up }.should change(User, :count).by(1)
	end

	scenario "when signing up a user their email gets added into th db" do
		sign_up
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "when signing up a user the index page welcomes them" do
		sign_up
		expect(page).to have_content("Welcome, alice@example.com")
	end

# this is a 'helper' method for Datamapper
	def sign_up(email = "alice@example.com", password = "oranges!")
		visit '/new'
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		fill_in :password, :with => password
		click_button "Sign up"
	end

end