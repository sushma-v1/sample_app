require 'spec_helper'

describe "AuthenticationPages" do

  #describe "GET /authentication_pages" do
    #it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      #get authentication_pages_index_path
      #response.status.should_be(200)
    #end
  #end

  describe "Authentication" do
    subject { page }

    describe "signin page" do
      before { visit signin_path }

      describe "with invalid information" do
        before { click_button "Sign In" }
        it { should have_selector('h1', text: 'Sign in') }
        it { should have_selector('title', text: 'Sign in') }
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }

        describe "followed by Signout" do
          before { click_link "Sign out" }
          #before { find('link_to', :text => 'Sign out').click }
          it { should have_link 'Sign in' }
        end
      end

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }
        it { should have_selector('title', text: user.name) }
        it { should have_link("Users", href: users_path) }
        it { should have_link("Profile", href: user_path(user)) }
        it { should have_link("Settings", href: edit_user_path(user)) }
        it { should have_link("Sign out", href: signout_path) }
        it { should_not have_link("Sign in", href: signin_path) }
      end

    end

    describe "authorization" do
      describe "for non-signed-in users" do
        describe "in the Users controller" do
          describe "visiting the user index" do
            before { visit users_path }
            it { should have_selector('title', text: 'Sign in') }
          end
        end
      end
    end

  end

  #describe "after visiting another page" do
    #before { click_link "Home" }
    #it { should_not have_selector('div.alert.alert-error') }
  #end

end
