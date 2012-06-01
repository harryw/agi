require 'spec_helper'

describe PirDeployment do

  before :each do
    @deployment = build(:deployment)
    @pir_deployment = PirDeployment.new(@deployment)
  end

  describe "#initialize" do

    it "creates a new object given a deployment" do
      @pir_deployment.should be
    end

  end

  describe "#get_medistrano_pir!" do

    context "when the app's security group is valid" do

      before :each do
        @project_name = 'fake_project_name'
        @stage_name = 'fake_stage_name'
        @cloud_name = 'fake_cloud_name'
        @deployment.stub(:app_ec2_sg_to_authorize).and_return("#@project_name-#@stage_name-#@cloud_name")
        @pir_bucket = 'fake_pir_bucket'
        @pir_key = "#@project_name/IQ/#@project_name-#@stage_name-PIR.pdf"
        @pir_document = double(:pir_document)
        S3Storage.stub(:config).and_return({
            'medistrano_pir_bucket_name' => @pir_bucket
        })
      end

      it "looks for the Medistrano PIR in the right place in S3" do
        S3Storage.should_receive(:fetch).with(@pir_bucket, @pir_key).and_return(@pir_document)
        @pir_deployment.get_medistrano_pir!
      end

      context "and the PIR exists in S3" do

        context "and the PIR is accessible" do

          before { S3Storage.stub(:fetch).with(@pir_bucket, @pir_key).and_return(@pir_document) }

          it "fetches the PIR" do
            returned = @pir_deployment.get_medistrano_pir!
            returned.should == @pir_document
          end

        end

        context "and the PIR is not accessible" do

          before { S3Storage.stub(:fetch).with(@pir_bucket, @pir_key).and_raise }

          it "raises an exception" do
            expect { @pir_deployment.get_medistrano_pir! }.to raise_exception
          end

        end

      end

      context "and the PIR does not exist in S3" do

        before { S3Storage.stub(:fetch).with(@pir_bucket, @pir_key).and_return(nil) }

        it "raises an exception" do
          expect { @pir_deployment.get_medistrano_pir! }.to raise_exception
        end

      end

    end


    context "when the app's security group is blank" do

      before { @deployment.stub(:app_ec2_sg_to_authorize).and_return('') }

      it "raises an exception" do
        expect { @pir_deployment.get_medistrano_pir! }.to raise_exception
      end

    end

    context "when the app's security group is invalid" do

      before { @deployment.stub(:app_ec2_sg_to_authorize).and_return('invalid security group') }

      it "raises an exception" do
        expect { @pir_deployment.get_medistrano_pir! }.to raise_exception
      end

    end

  end

  describe "#merge_pir_with_iq" do

    before :each do
      @pdftk = double()
      ActivePdftk::Wrapper.stub(:new).and_return(@pdftk)
      @merged_content = double()
      @pdftk.stub_chain(:cat, :string).and_return(@merged_content)
      bottomless_hash = {}
      bottomless_hash.stub(:[]).and_return(bottomless_hash)
      bottomless_hash.stub(:to_s).and_return('test')
      @deployment.deployed_data = bottomless_hash
      @deployment.stub(:app_ec2_sg_to_authorize).and_return('project-stage-cloud')
      S3Storage.stub(:fetch).and_return('fake_document')
    end

    it "fetches the PIR using #get_medistrano_pir!" do
      @pir_deployment.should_receive(:get_medistrano_pir!)
      @pir_deployment.merge_pir_with_iq
    end

    it "generates a new IQ document" do
      iq_deployment = double()
      IqDeployment.stub(:new).with(@deployment.deployed_data, @deployment.deploying_time).and_return(iq_deployment)
      iq_deployment.should_receive(:render)
      @pir_deployment.merge_pir_with_iq
    end

    it "concatenates the PIR and IQ" do
      @pdftk.should_receive(:cat).with(any_args)
      @pir_deployment.merge_pir_with_iq
    end

    it "returns the result of the merge" do
      returned = @pir_deployment.merge_pir_with_iq
      returned.should == @merged_content
    end

  end

end
