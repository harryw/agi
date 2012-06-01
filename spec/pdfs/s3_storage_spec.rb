require 'spec_helper'

describe S3Storage do

  before :each do
    @s3 = double(:s3)
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
      @bucket = double(:bucket)
      @directories = double(:directories)
      @files = double(:files)
      @s3.stub(:get_bucket).with(@bucket_name).and_return(@bucket)
      @s3.stub(:directories).and_return(@directories)
      @directories.stub(:get).with(@bucket_name).and_return(@bucket)
      @bucket.stub(:files).and_return(@files)
      @files.stub(:create).with(key: @key, body: @value)
    end

    context "when the specified bucket doesn't exist" do

      before :each do
        @s3.stub(:get_bucket).with(@bucket_name).and_raise(StandardError)
      end

      it "creates the bucket" do
        @s3.should_receive(:put_bucket).with(@bucket_name)
        S3Storage.store(@bucket_name, @key, @value)
      end

      it "still stores the key/value pair" do
        @s3.stub(:put_bucket).with(@bucket_name)
        @files.should_receive(:create).with(key: @key, body: @value)
        S3Storage.store(@bucket_name, @key, @value)
      end

    end

    it "creates the specified key in the specified bucket with the specified value" do
      @files.should_receive(:create).with(key: @key, body: @value)
      S3Storage.store(@bucket_name, @key, @value)
    end

    it "parses and re-raises excon exceptions" do
      code = 'fake_code'
      message = 'fake_message'
      excon_exception = "<Code>#{code}</Code>blah blah blah<Message>#{message}</Message>"
      @files.stub(:create).with(key: @key, body: @value).and_raise(excon_exception)
      expect { S3Storage.store(@bucket_name, @key, @value) }.to raise_exception("#{code} => #{message}")
    end

  end

  describe ".fetch" do

    before :each do
      @bucket_name = 'fake_bucket'
      @key = 'fake_key'
      @value = 'fake_value'
      @bucket = double()
      @s3.stub_chain(:directories, :get).with(@bucket_name).and_return(@bucket)
      @document = double()
      @bucket.stub_chain(:files, :get).with(@key).and_return(@document)
      @document.stub(:body).and_return(@value)
    end

    it "finds the specified bucket" do
      directories = double()
      @s3.stub(:directories).and_return(directories)
      directories.should_receive(:get).with(@bucket_name)
      S3Storage.fetch(@bucket_name, @key)
    end

    it "returns nil if the bucket is not found" do
      @s3.stub_chain(:directories, :get).with(@bucket_name).and_return(nil)
      returned = S3Storage.fetch(@bucket_name, @key)
      returned.should be_nil
    end

    it "finds the specified key" do
      files = double()
      @bucket.stub(:files).and_return(files)
      files.should_receive(:get).with(@key)
      S3Storage.fetch(@bucket_name, @key)
    end

    it "returns nil if the key is not found" do
      @bucket.stub_chain(:files, :get).with(@key).and_return(nil)
      returned = S3Storage.fetch(@bucket_name, @key)
      returned.should be_nil
    end

    it "returns the body of the value for the given key" do
      returned = S3Storage.fetch(@bucket_name, @key)
      returned.should == @value
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