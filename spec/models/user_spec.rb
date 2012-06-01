describe User do

  before(:each) do
    @user = build(:user)
  end

  it 'should be valid with valid attributes' do
    @user.should be_valid
  end

  it 'requires a username, of at least 5 characters' do
    @user.username = nil
    @user.should_not be_valid
  end

  it 'requires the username to be at least 5 characters' do
    @user.username = '1234'
    @user.should_not be_valid
  end

end
