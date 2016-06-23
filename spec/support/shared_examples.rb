shared_examples "requires sign in" do
  it "redirects to the sign in page" do
    session[:user_id] = nil
    action
    expect(response).to redirect_to sign_in_path
  end
end

shared_examples "generates token" do
  it "generates token" do
    object.generate_token
    expect(object.token).not_to be_nil
  end
end
