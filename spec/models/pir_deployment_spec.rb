require 'spec_helper'


describe Deployment do
  before(:all) do
    Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable = true
    @medistrano_pir_bucket_name = AppConfig["amazon_s3"]["medistrano_pir_bucket_name"]
  end
  

  # This feature uses the app ec2_sg_to_authorize field to extract the medistrano project name and the medistrano stage name. 
  # Medistrano PIRs are always store in the bucket "columbo-portal-current" and the 
  # path: "#{medistrano_project}/IQ/#{medistrano_project}-#{medistrano_stage}-PIR.pdf"
  

  
  describe "#get_medistrano_pir!" do 
    context "given app#ec2_sg_to_authorize isn't set" do
      before(:each) do
        @app = Factory.build(:app, :ec2_sg_to_authorize=>'')
        @deployment = Factory.build(:deployment, :app => @app)
      end
       
      it "raises an exception when ec2_sg_to_authorize is empty" do
        expect{@deployment.get_medistrano_pir!}.
          to raise_error(RuntimeError, "ec2_sg_to_authorize isn't set, Agi can't determine the medistrano project and stage")
      end
    end
  end
  
  describe '#save_iq_file' do
    before(:each) do
      @app = Factory.build(:app, :ec2_sg_to_authorize=>'ctms-sandbox-app001java')
      @deployment = Factory.build(:deployment, :app => @app)
    
      # location where the IQ will be uploaded in S3
      @medistrano_pir_key_name = @deployment.send(:medistrano_pir_key_name)
    
      #IQ requirements
      @deployment.send(:set_initial_status)
      @deployment.send(:save_deployed_data)
    
      # fog mocking
      @s3 = Fog::Storage[:aws]
      @pir_bucket = @s3.directories.create(:key => @medistrano_pir_bucket_name)
      @deployment.stub(:s3).and_return(@s3)
      @pir = PirDeployment.new(@deployment.send(:pir_params))
      @pir.stub(:s3).and_return(@s3)
    end
    
    context "given app#ec2_sg_to_authorize is set" do
    
      before(:each) do
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
          @deployment.stub(:merge_pir_with_iq).and_return(@pir.merge_pir_with_iq)
          @deployment.save_iq_file.should be_true      
          iq_size = @deployment.send(:generate_iq_file).size
          # the merged pdf is bigger than then Agi IQ
          @s3.directories.get(@iq_bucket).files.get(@s3_iq_key_name).body.size.should > iq_size
        end
    
      end
    end
  end
  
  
  describe "PirDeployment Class" do

    before(:each) do
      @pir_parmas = {
        :medistrano_pir_key_name => 'medistrano_fake_pir.pdf',
        :medistrano_pir_bucket_name => 'fake_pir_bucket',
        :deployed_data => deployed_data,
        :deploying_time => Time.now
      }
      @pir = PirDeployment.new(@pir_parmas)
      @s3 = Fog::Storage[:aws]
      @pir_bucket = @s3.directories.create(:key => @pir_parmas[:medistrano_pir_bucket_name])
      @pir.stub(:s3).and_return(@s3)
    end
  
    describe "#get_medistrano_pir!" do
      context "given Medistrano PIR doesn't exist" do
    
        it "raises an exception" do
          expect{@pir.get_medistrano_pir!}.
            to raise_error(RuntimeError, "fake_pir_bucket/medistrano_fake_pir.pdf doesn't exist. Go to Medistrano and generate the PIR")
        end
        
      end
      
      context "given Medistrano PIR exists" do
        before(:each) { @pir_s3 = @pir_bucket.files.create(:key=> @pir_parmas[:medistrano_pir_key_name], :body => create_pdf('this is a PIR')) }
        
        it "returns the medistrano pir content" do
          @pir.get_medistrano_pir!.should == create_pdf('this is a PIR')
        end
        
      end
    end
    
    describe "#merge_pir_with_iq" do
      before(:each) { @iq_size = @pir.send(:generate_iq_file).size }
      
      context "given #get_medistrano_pir! is stubed out" do
        before(:each) { @pir.stub(:get_medistrano_pir!).and_return(create_pdf('this is a PIR')) }
      
        it "merges iq and pir turnning into a bigger than that the Agi IQ" do
          @pir.merge_pir_with_iq.size.should > @iq_size
        end
      end
      
      context "given Medistrano PIR exists" do
        before(:each) { @pir_s3 = @pir_bucket.files.create(:key=> @pir_parmas[:medistrano_pir_key_name], :body => create_pdf('this is a PIR')) }

        it "merges iq and pir turnning into a bigger than that the Agi IQ" do
          @pir.merge_pir_with_iq.size.should > @iq_size
        end
      end
    end
      
  end
  
  def create_pdf(text)
    pdf = Prawn::Document.new
    pdf.text text
    pdf.render
  end
  
  def deployed_data
    {:id=>"ctms-medidata-rodrigo",
     :deployment_timestamp=>'2012-04-30 17:20:59 UTC',
     :main=>
      {:name=>"ctms-medidata-rodrigo",
       :stage_name=>"rodrigo",
       :deploy_to=>"/mnt/ctms-medidata-rodrigo",
       :deploy_user=>"medidata",
       :deploy_group=>"medidata",
       :uses_bundler=>true,
       :git_branch=>"master",
       :required_packages=>
        ["ttf-dejavu",
         "ttf-liberation",
         "libxerces2-java",
         "libxerces2-java-gcj",
         "mysql-client"],
       :platform=>"ctms",
       :force_deploy=>false,
       :send_email=>false,
       :task=>"",
       :run_migrations=>true,
       :migration_command=>"",
       :deployment_timestamp=>'2012-04-30 17:20:59 UTC',
       :deploy_by=>"restebanez@mdsol.com",
       :deployed_at=>'2012-05-22 16:22:33 +0200'},
     :project=>
      {:name=>"CTMS",
       :name_tag=>"ctms",
       :homepage=>"https://sites.google.com/a/mdsol.com/product/product/CTMS",
       :repository=>"git@github.com:mdsol/ctms.git",
       :platform=>"ctms",
       :custom_data=>{"hancer"=>"4", "dfdf"=>"dfdf", "jj"=>"jj", "test"=>"test"}},
     :customer=>
      {:name=>"Medidata",
       :name_tag=>"medidata",
       :custom_data=>{"dfdf"=>"dfdf", "jj"=>"jj"}},
     :database=>
      {:name=>"ctms-medidata-rodrigo",
       :db_name=>"imedidata_performance",
       :username=>"imedidata",
       :db_type=>"mysql",
       :hostname=>nil}}
  end
end
