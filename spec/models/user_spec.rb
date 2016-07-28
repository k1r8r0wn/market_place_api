require 'rails_helper'

describe User, type: :model do
  before { @user = create(:user) }

  subject { @user }

  it { should respond_to(:email) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }

  it { should be_valid } 
end
