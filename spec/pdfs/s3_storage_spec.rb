require 'spec_helper'

describe S3Storage do

  before :each do
    @s3 = Fog::Storage::AWS.new(aws_access_key_id: 'xxxxx', aws_secret_access_key: 'xxxxx')
    Fog::Storage::AWS.stub(:new).and_return(@s3)
  end

  describe ".url_for" do

    it "returns a URL given a bucket name and key" do
      S3Storage.url_for('bucket', 'key').should == "https://bucket.s3.amazonaws.com/key"
    end

    it "URL-encodes the bucket and key" do
      S3Storage.url_for('another bucket', 'the key').should == "https://another%20bucket.s3.amazonaws.com/the%20key"
    end

  end

  describe ".store" do

    before :each do
      @bucket_name = 'fake_bucket'
      @key = 'fake_key'
      @value = 'fake_value'
    end

    context "when the specified bucket doesn't exist" do

      before :each do
        @s3.delete_bucket(@bucket_name) rescue nil
      end

      it "creates the bucket" do
        S3Storage.store(@bucket_name, @key, @value)
        @s3.get_bucket(@bucket_name).status.should == 200
      end

      it "still stores the key/value pair" do
        S3Storage.store(@bucket_name, @key, @value)
        @s3.directories.get(@bucket_name).files.get(@key).body.should == @value
      end

    end

    context "when the specified bucket already exists" do

      before :each do
        @s3.get_bucket(@bucket_name) rescue @s3.put_bucket(@bucket_name)
      end

      it "creates the specified key in the specified bucket with the specified value" do
        S3Storage.store(@bucket_name, @key, @value)
        @s3.directories.get(@bucket_name).files.get(@key).body.should == @value
      end

    end

    it "parses and re-raises excon exceptions" do
      code = 'fake_code'
      message = 'fake_message'
      excon_exception = "<Code>#{code}</Code>blah blah blah<Message>#{message}</Message>"
      @s3.stub_chain(:directories, :get).and_raise(excon_exception)
      expect { S3Storage.store(@bucket_name, @key, @value) }.to raise_exception("#{code} => #{message}")
    end

  end

  describe ".fetch" do

    before :each do
      @bucket_name = 'fake_bucket'
      @key = 'fake_key'
      @value = 'fake_value'
    end

    context "when the bucket doesn't exist" do

      before :each do
        @s3.delete_bucket(@bucket_name) rescue nil
      end

      it "returns nil" do
        returned = S3Storage.fetch(@bucket_name, @key)
        returned.should be_nil
      end

    end

    context "when the bucket exists" do

      before :each do
        @s3.get_bucket(@bucket_name) rescue @s3.put_bucket(@bucket_name)
      end

      context "when the file doesn't exist" do

        before :each do
          @s3.directories.get(@bucket_name).files.delete(@key)
        end

        it "returns nil" do
          returned = S3Storage.fetch(@bucket_name, @key)
          returned.should be_nil
        end

      end

      context "when the file exists" do

        before :each do
          @s3.directories.get(@bucket_name).files.create(key: @key, body: @value)
        end

        it "returns the body of the value for the given key" do
          returned = S3Storage.fetch(@bucket_name, @key)
          returned.should == @value
        end

      end

    end

    it "parses and re-raises excon exceptions" do
      code = 'fake_code'
      message = 'fake_message'
      excon_exception = "<Code>#{code}</Code>blah blah blah<Message>#{message}</Message>"
      @s3.stub_chain(:directories, :get).with(@bucket_name).and_raise(excon_exception)
      expect { S3Storage.fetch(@bucket_name, @key) }.to raise_exception("#{code} => #{message}")
    end

  end

  describe ".config" do

    it "returns the S3 config set in AppData" do
      s3_config = double()
      AppConfig.stub(:[]).with("amazon_s3").and_return(s3_config)
      S3Storage.config.should == s3_config
    end

  end

end