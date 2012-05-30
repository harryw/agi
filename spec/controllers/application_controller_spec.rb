require 'spec_helper'

describe AppsController do  # (Testing AppController authentication indirectly)

  context "with no iMedidata ticket" do
    before do
      CASClient::Frameworks::Rails::Filter.unstub!(:filter)
    end
    it "redirects to iMedidata for login" do
      get :index
      response.status.should == 302
      response.headers['Location'].should match(
        /\A#{IMEDIDATA_CLIENT_CONFIG[:imedidata_cas_url]}\/login\?service=/
      )
    end
  end

end
