require 'spec_helper'

describe Deployment do

  before :each do
    @app = Factory.build(:app)
    @deployment = Factory.build(:deployment, :app => @app)
    @pir_deployment = double()
    PirDeployment.stub(:new).with(@deployment).and_return(@pir_deployment)
  end

  describe "creation" do
    #TODO: add tests here to verify that the after_save hooks are doing what they're supposed to do
    #REVIEW: do we really want to use those hooks anyway?  Why not just use plain old #initialize?
  end

  describe "#get_medistrano_pir!" do

    it "calls PirDeployment#get_medistrano_pir!" do
      @pir_deployment.should_receive(:get_medistrano_pir!)
      @deployment.get_medistrano_pir!
    end

    it "returns whatever PirDeployment#get_medistrano_pir! returns" do
      returned = Object.new
      @pir_deployment.stub(:get_medistrano_pir!).and_return(returned)
      @deployment.get_medistrano_pir!.should be returned;
    end

    it "does not hide exceptions" do
      e = Exception.new
      @pir_deployment.stub(:get_medistrano_pir!).and_raise(e)
      expect {@deployment.get_medistrano_pir!}.to raise_exception(e)
    end

  end

  describe "#save_iq_file" do

    before :each do
      @app_name = 'fake_app_name'
      @app.stub(:name).and_return(@app_name)
      @deployed_data = double()
      @deployment.deployed_data = @deployed_data
      @time = Time.at(123456789)
      Time.stub(:now).and_return(@time)
      @iq_deployment = double()
      IqDeployment.stub(:new).with(@deployed_data, @time).and_return(@iq_deployment)
      @iq_folder_name = 'fake_folder_name'
      @iq_bucket_name = 'fake_bucket_name'
      @config_iq_bucket_name = "#@iq_bucket_name/#@iq_folder_name"
      @pir_bucket_name = 'fake_pir_bucket_name'
      S3Storage.stub(:config).and_return({
          'bucket_name' => @config_iq_bucket_name,
          'medistrano_pir_bucket_name' => @pir_bucket_name
      })
      S3Storage.stub(:store)
      @iq_file_name = "#@iq_folder_name/#@app_name/#@app_name-#{@time.to_s(:number)}.pdf"
      @iq_document = double()
      @iq_deployment.stub(:render).and_return(@iq_document)
      @pir_document = double()
      @pir_deployment.stub(:get_medistrano_pir!).and_return(@pir_document)
    end

    it "creates an IQ PDF file" do
      @iq_deployment.should_receive(:render)
      @deployment.save_iq_file
    end

    it "passes the deployment data to IqDeployment" do
      IqDeployment.should_receive(:new).with(@deployed_data, @time)
      @deployment.save_iq_file
    end

    it "uploads the file" do
      @pir_deployment.stub(:merge_pir_with_iq).and_return(@iq_document)
      S3Storage.should_receive(:store).with(@iq_bucket_name, @iq_file_name, @iq_document)
      @deployment.save_iq_file
    end

    context "when the 'merge with PIR' flag is set" do

      before :each do
        Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable = true
        @deployment.merge_iq_with_medistrano_pir = true
      end

      context "and the PIR is accessible" do

        it "merges the IQ and the PIR and uploads the result" do
          merged_document = double()
          @pir_deployment.should_receive(:merge_pir_with_iq).and_return(merged_document)
          S3Storage.should_receive(:store).with(@iq_bucket_name, @iq_file_name, merged_document)
          @deployment.save_iq_file
        end

      end

      context "and the PIR is not accessible" do

        before :each do
          @access_exception = Exception.new(:fake_access_exception)
          @pir_deployment.stub(:merge_pir_with_iq).and_raise(@access_exception)
        end

        it "does not hide the exception" do
          expect { @deployment.save_iq_file }.to raise_exception(@access_exception)
        end

      end

    end

    context "when the 'merge with PIR' flag is unset" do

      before :each do
        Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable = true
        @deployment.merge_iq_with_medistrano_pir = false
      end

      it "uploads just the IQ" do
        merged_document = double()
        @pir_deployment.stub(:merge_pir_with_iq).and_return(merged_document)
        S3Storage.should_receive(:store).with(@iq_bucket_name, @iq_file_name, @iq_document)
        @deployment.save_iq_file
      end

    end

    context "when the 'merge with PIR' feature is disabled" do

      before :each do
        Rails.application.config.feature_merge_medistrano_pir_with_agi_iq_is_enable = false
        @deployment.merge_iq_with_medistrano_pir = true
      end

      it "uploads just the IQ" do
        merged_document = double()
        @pir_deployment.stub(:merge_pir_with_iq).and_return(merged_document)
        S3Storage.should_receive(:store).with(@iq_bucket_name, @iq_file_name, @iq_document)
        @deployment.save_iq_file
      end

    end

  end

  describe "#deploying_time" do

    it "returns a time" do
      @deployment.deploying_time.should be_a Time
    end

    it "returns the current time on the first call" do
      @time = Time.at(123456789)
      Time.stub(:now).and_return(@time)
      @deployment.deploying_time.should == @time
    end

    it "returns the same time on the second and subsequent calls" do
      first_time = @deployment.deploying_time
      5.times do
        @deployment.deploying_time.should == first_time
      end
    end

  end

end