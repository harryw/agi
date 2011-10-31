require 'vcr'

VCR.configure do |c|
  c.hook_into :fakeweb
  c.cassette_library_dir     = 'fixtures/vcr_cassettes'
end

VCR.cucumber_tags do |t|
  t.tag  '@localhost_request' # uses default record mode since no options are given
  t.tags '@disallowed_1', '@disallowed_2', :record => :none
end