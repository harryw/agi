require 'spec_helper'

# TODO
# test that an error is raise when ec2_sg_to_authorize isn't set

describe Deployment do
  before(:all) do
    Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable = true
    @medistrano_pir_bucket_name = AppConfig["amazon_s3"]["medistrano_pir_bucket_name"]
  end
  
  before(:each) do
    @app = Factory.build(:app)
  end

  # This feature uses the app ec2_sg_to_authorize field to extract the medistrano project name and the medistrano stage name. 
  # Medistrano PIRs are always store in the bucket "columbo-portal-current" and the 
  # path: "#{medistrano_project}/IQ/#{medistrano_project}-#{medistrano_stage}-PIR.pdf"
  
  context "given app#ec2_sg_to_authorize isn't set" do
    before(:each) do
      @app.stub(:ec2_sg_to_authorize).and_return('')
      @deployment = Factory.build(:deployment, :app => @app)
    end
    
    describe "#get_medistrano_pir!" do    
      it "raises an exception when ec2_sg_to_authorize is empty" do
        expect{@deployment.get_medistrano_pir!}.to raise_error(RuntimeError)
      end
    end
  end
  
  context "given app#ec2_sg_to_authorize is set" do
    before(:each) do
      @app.stub(:ec2_sg_to_authorize).and_return('ctms-sandbox-app001java')
      @deployment = Factory.build(:deployment, :app => @app)

      # location where the IQ will be uploaded in S3
      @medistrano_pir_key_name = @deployment.send(:medistrano_pir_key_name)

      # fog mocking
      @s3 = Fog::Storage[:aws]
      @pir_bucket = @s3.directories.create(:key => @medistrano_pir_bucket_name)
      @deployment.stub(:s3).and_return(@s3)    
    end
  
    describe "#get_medistrano_pir!" do
      context "given Medistrano PIR doesn't exist" do
    
        it "raises an exception" do
          expect{@deployment.get_medistrano_pir!}.to raise_error(RuntimeError)
        end
        
      end
      
      context "given Medistrano PIR exists" do
        before(:each) { @pir_s3 = @pir_bucket.files.create(:key=> @medistrano_pir_key_name, :body => create_pdf('this is a PIR')) }
        
        it "returns the medistrano pir content" do
          @deployment.get_medistrano_pir!.should == create_pdf('this is a PIR')
        end
        
        after(:each){ @pir_s3.destroy }
      end
    end
      
    
    describe '#save_iq_file' do
      before(:each) do
        #IQ requirements
        @deployment.send(:set_initial_status)
        @deployment.send(:save_deployed_data)
        
        # S3 bucket name and key name
        @iq_bucket = @deployment.send(:iq_bucket)
        @s3_iq_key_name = @deployment.send(:s3_key_name)
      end
      
      context "when the merging flag isn't set" do
    
        it "uploads only the Agi IQ " do
          @deployment.should_receive(:merge_iq_with_medistrano_pir).and_return(false) # merge flag
          @deployment.save_iq_file.should be_true
          @s3.directories.get(@iq_bucket).files.get(@s3_iq_key_name).body.should == @deployment.send(:generate_iq_file)
        end
        
      end
      
      context "when the merging flag is set" do
        
        it "merges and uploads" do
          @pir_s3 = @pir_bucket.files.create(:key=> @medistrano_pir_key_name, :body => create_pdf('this is a PIR'))
          @deployment.should_receive(:merge_iq_with_medistrano_pir).and_return(true) # merge flag
          @deployment.save_iq_file.should be_true      
          iq_size = @deployment.send(:generate_iq_file).size
          # the merged pdf is bigger than then Agi IQ
          @s3.directories.get(@iq_bucket).files.get(@s3_iq_key_name).body.size.should > iq_size
        end 
        
      end
    end
  end
  
  def create_pdf(text)
    pdf = Prawn::Document.new
    pdf.text text
    pdf.render
  end
end
