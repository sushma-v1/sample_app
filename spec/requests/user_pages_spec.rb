require 'spec_helper'

describe "User Pages" do
  let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  subject{ page }

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "anil", email: "anil@email.com")
      FactoryGirl.create(:user, name: "anu", email: "anu@email.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1', text: 'All users') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) {FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect { click link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }

      end
    end

  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before { visit edit_user_path(user) }
    describe "page" do
      it { should have_selector('h1', text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }
      it { should have_content('error') }
    end
  end

  describe "Signup Page" do
    before{ visit signup_path }
    it{ should have_selector('h1', text: 'Sign Up') }
    it{ should have_selector('title', :text => "#{base_title} ") }
    it{ should have_selector('title', :text => "| Sign Up") }
    #it{ should have_selector('title', text: full_title('Sign Up')) }
  end

  describe "profile page" do
    # Code to make a user variable before { visit user path(user) }
    it { should have_selector('h1', text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
       expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Suma"
        fill_in "Email", with: "Suma@email.com"
        fill_in "Password", with: "sumpapa"
        fill_in "Password_confirmation", with: "sumpapa"
      end
      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end

    describe "after saving the user" do
      it { should have_link('Sign out') }
    end

  end

end
