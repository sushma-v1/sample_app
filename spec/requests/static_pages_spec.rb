require 'spec_helper'

describe "Static pages" do
  let(:base_title) {"Ruby on Rails Tutorial Sample App"}
  subject { page }

  describe "Home Page" do
    before { visit root_path }
    it{ should have_selector('h1', :text => "sample App") }
    it{ should have_selector('title', :text => "#{base_title} ") }
    it{ should have_selector('title', :text => "| Home") }
  end

  describe "Help Page" do
    before { visit help_path }
    it{ should have_content('Help') }
    it{ should have_selector('title', :text => "#{base_title} ") }
    it{ should have_selector('title', :text => "| Help") }
  end

  describe "About Page" do
    before{ visit about_path }
    it{ should have_content('About Us') }
    it{ should have_selector('title', :text => "#{base_title} ") }
    it{ should have_selector('title', :text => "| About") }
  end

  describe "Contact Page" do
    before{ visit contact_path }
    it{ should have_selector('title', :text => "#{base_title} ") }
    it{ should have_selector('title', :text => "| Contact") }
  end

end
