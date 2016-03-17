# == Schema Information
#
# Table name: users
#
#  id                    :integer         not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#  password_digest       :string(255)
#  password              :string(255)
#  password_confirmation :string(255)
#  remember_token        :string(255)
#  admin                 :boolean         default(FALSE)
#

require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example user", email: "user@email.com", password: "foobar", password_confirmation: "foobar")}
  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }

  it { should be_valid }
  it { should_not be_admin }
  it { should respond_to(:followed_users) }
  it { should respond_to(:followers) }
  it { should respond_to(:followin?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  it { should respond_to(:relationships) }
  it { should respond_to(:reverse_relationships) }

  describe "with admin attribute set to 'true'" do
    before { @user.toggle!(:admin) }
    it { should be_admin}
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name length exceeds limit" do
    before { @user.name > 50 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user at foo.org example.user@foo.
foo@barbaz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end
    end
  end

  describe "when password is not present" do
    before { @user.password = @user.password confirmation = " " }
    it { should_not be valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password confirmation = "mismatch" }
    it { should_not be valid }
  end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end
    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end

    describe " and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
  end

end
