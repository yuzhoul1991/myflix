shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "requires admin" do
  it 'redirect non admin user to home path' do
    session[:user_id] = Fabricate(:user).id
    action
    expect(response).to redirect_to home_path
  end
  it 'sets flash error message' do
    session[:user_id] = Fabricate(:user).id
    action
    expect(flash[:error]).not_to be_nil
  end
end

shared_examples "generates token" do
  it "generates token" do
    object.generate_token
    expect(object.token).not_to be_nil
  end
end
