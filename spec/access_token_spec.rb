describe SimpleWx::AccessToken do
  it "get access_token" do
    at = SimpleWx::AccessToken.new
    at_str = at.access_token
    expect(at_str.empty?).to eq false
    expect(at.error.empty?).to eq true
  end
end