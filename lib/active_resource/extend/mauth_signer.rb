# Monkey Patch to hook Mauth Signer into ActiveResource
module ActiveResource #:nodoc:
  module Extend
    module MauthSigner
       class ActiveResource::Connection
         # get request(:get, path, build_request_headers(headers, :get, self.site.merge(path)))
         # delete request(:delete, path, build_request_headers(headers, :delete, self.site.merge(path)))
         # put request(:put, path, body.to_s, build_request_headers(headers, :put, self.site.merge(path)))
         # post request(:post, path, body.to_s, build_request_headers(headers, :post, self.site.merge(path)))
         
         alias_method :old_request, :request
         
         def request(method, path, *arguments)
           mauth_settings= YAML.load_file(File.join(Rails.root, "config", "mauth_settings.yml"))[:mauth]

           post_data = [:put, :post].include?(method) ? arguments.first : nil

           h = MAuth::Signer.new(mauth_settings[:private_key]).signed_headers(:app_uuid => mauth_settings[:app_uuid], :request_url => path, :post_data => post_data, :verb => method.upcase.to_s)
           arguments.last["Authorization"]=h["Authorization"]
           arguments.last["x-mws-time"]=h["x-mws-time"]

           old_request(method, path, *arguments)
         end
       end
     end
  end  
end