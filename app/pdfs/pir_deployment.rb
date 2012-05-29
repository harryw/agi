class PirDeployment

  def initialize(deployment)
    @deployment = deployment
  end
  
  def get_medistrano_pir!
    medistrano_pir = S3Storage.fetch(medistrano_pir_bucket_name, medistrano_pir_key_name)
    raise "doesn't exist. Go to Medistrano and generate the PIR" unless medistrano_pir
    medistrano_pir
  end

  def merge_pir_with_iq
    pdftk = ActivePdftk::Wrapper.new
    pdftk.cat([{:pdf => save_medistrano_pir},{:pdf=> save_agi_iq}]).string
  end
  
private

    def generate_iq_file
      pdf = IqDeployment.new(@deployment.deployed_data, @deployment.deploying_time)
      pdf.render
    end

    def save_medistrano_pir
      @pir_file = Tempfile.open(['medistrano-pir','.pdf'], Rails.root.join('tmp'), :encoding => 'ascii-8bit' )
      @pir_file.write get_medistrano_pir!
      @pir_file.close
      @pir_file.path
    end
    
    def save_agi_iq
      @iq_file = Tempfile.open(['agiapp-iq','.pdf'], Rails.root.join('tmp'), :encoding => 'ascii-8bit' )
      @iq_file.write generate_iq_file
      @iq_file.close
      @iq_file.path
    end
    
  def medistrano_pir_bucket_name
    S3Storage.config["medistrano_pir_bucket_name"]
  end

  def medistrano_pir_key_name
    raise "ec2_sg_to_authorize isn't set, Agi can't determine the medistrano project and stage" if app_ec2_sg_to_authorize.blank?
    medistrano_project, medistrano_stage, medistrano_cloud = app_ec2_sg_to_authorize.split(/-/)
    "#{medistrano_project}/IQ/#{medistrano_project}-#{medistrano_stage}-PIR.pdf"
  end

end