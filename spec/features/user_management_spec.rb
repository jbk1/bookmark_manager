
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
	
	scenario "with an unmatching password & doesn't save to db" do 
		lambda { sign_up('a@a.com', 'pass', 'wrong') }.should change(User, :count).by(0)
	end

		def sign_up(email = "alice@example.com",
							password = "oranges!",
							password_confirmation = "oranges!")
			visit '/new'
			fill_in :email, :with => email
			fill_in :password, :with => password
			fill_in :password_confirmation, :with => password_confirmation
			click_button "Sign up"
		end

end