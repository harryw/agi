require 'spec_helper'


describe Deployment do
  before(:each) do
    Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable = true
    
    @bucket_name = 'medistrano-fake-bucket'
    @key_name = 'ctms/IQ/ctms-fake-PIR.pdf'
    
    @app = Factory.build(:app)
    @deployment = Factory.build(:deployment, :app => @app)
    @deployment.stub(:new_record?).and_return(false)
    @deployment.stub(:medistrano_pir_bucket_name).and_return(@bucket_name)
    @deployment.stub(:medistrano_pir_key_name).and_return(@key_name)
    
    #IQ requirements
    @deployment.send(:set_initial_status)
    @deployment.send(:save_deployed_data)
    
    # S3 bucket name and key name
    @iq_bucket = @deployment.send(:iq_bucket)
    @s3_key_name = @deployment.send(:s3_key_name)
    
    # fog mocking
    @s3 = Fog::Storage[:aws]
    @deployment.stub(:s3).and_return(@s3)
    @bucket = @s3.directories.create(:key => @bucket_name)
  end
  
  it "should raises if the Medistrano PIR doesn't exist" do
    file = @bucket.files.create(:key=> 'other-name', :body => 'pdf_content')
    expect{@deployment.get_medistrano_pir}.to raise_error(RuntimeError)
    file.destroy
  end

  it "should uploads only the Agi IQ when the merging flag isn't set" do
    @deployment.should_receive(:merge_iq_with_medistrano_pir).and_return(false) # merge flag
    @deployment.save_iq_file.should be_true
    @s3.directories.get(@iq_bucket).files.get(@s3_key_name).body.should == @deployment.send(:generate_iq_file)
  end
  
  it "should merges and uploads to S3 when merge flag is set" do
    file = @bucket.files.create(:key=> @key_name, :body => create_pdf('this is a PIR')) # creates a medistrano PIR in S3
    @deployment.get_medistrano_pir.should == create_pdf('this is a PIR') # searches for the file
    @deployment.should_receive(:merge_iq_with_medistrano_pir).and_return(true) # merge flag
    @deployment.save_iq_file.should be_true
    @s3.directories.get(@iq_bucket).files.get(@s3_key_name).body.should_not be_empty
    iq_size = @deployment.send(:generate_iq_file).size
    # the merged pdf is bigger than then Agi IQ
    @s3.directories.get(@iq_bucket).files.get(@s3_key_name).body.size.should > iq_size
    file.destroy
  end
  
  def create_pdf(text)
    pdf = Prawn::Document.new
    pdf.text text
    pdf.render
  end
end
