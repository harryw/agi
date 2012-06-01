class S3Storage

  def self.url_for(bucket, key)
    "https://#{URI.encode(bucket)}.s3.amazonaws.com/#{URI.encode(key)}"
  end

  def self.store(bucket, key, value)
    try_to_parse_excon_aws_error do
      s3.get_bucket(bucket) rescue s3.put_bucket(bucket)
      s3.directories.get(bucket).files.create(:key => key, :body => value)
    end
  end

  def self.fetch(bucket, key)
    try_to_parse_excon_aws_error do
      s3_bucket = s3.directories.get(bucket)
      s3_file = s3_bucket.files.get(key) if s3_bucket
      s3_file.body if s3_file
    end
  end

  def self.config
    AppConfig["amazon_s3"]
  end

  private

  def self.s3
    Fog::Storage::AWS.new(aws_access_key_id: config["access_key_id"],
        aws_secret_access_key: config["secret_access_key"])
  end

  def self.try_to_parse_excon_aws_error(&block)
    begin
      yield
    rescue => e
      if match = e.message.match(/<Code>(.*)<\/Code>[\s\\\w]*<Message>(.*)<\/Message>/m)
        raise "#{match[1].split('.').last} => #{match[2]}"
      else
        raise
      end
    end
  end

end
