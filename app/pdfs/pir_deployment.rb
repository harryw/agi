class PirDeployment
  
  def initialize(pir_params)
    @pir_params = pir_params
    # necessary hash keys: :medistrano_pir_bucket_name, :medistrano_pir_key_name, :access_key_id, :secret_access_key, :deployed_data,:deploying_time
  end
  
  def get_medistrano_pir!
    begin
      if medistrano_pir_handler = s3.directories.get(@pir_params[:medistrano_pir_bucket_name]).files.get(@pir_params[:medistrano_pir_key_name])
        medistrano_pir = medistrano_pir_handler.body
      else
        raise "doesn't exist. Go to Medistrano and generate the PIR"
      end
    rescue => e          
      raise "#{@pir_params[:medistrano_pir_bucket_name]}/#{@pir_params[:medistrano_pir_key_name]} #{try_to_parse_excon_aws_error(e)}"
    end
    medistrano_pir                    
  end

  def merge_pir_with_iq
    pdftk = ActivePdftk::Wrapper.new
    pdftk.cat([{:pdf => save_medistrano_pir},{:pdf=> save_agi_iq}]).string
  end
  
private

    def generate_iq_file
      pdf = IqDeployment.new(@pir_params[:deployed_data],@pir_params[:deploying_time])
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
    
    def try_to_parse_excon_aws_error(rescue_error_msg)
      if match = rescue_error_msg.message.match(/<Code>(.*)<\/Code>[\s\\\w]*<Message>(.*)<\/Message>/m)
        "#{match[1].split('.').last} => #{match[2]}"
      else
        rescue_error_msg.message
      end
    end
    
    def s3
      @s3 ||= Fog::Storage::AWS.new(:aws_access_key_id => @pir_params[:access_key_id],
                                    :aws_secret_access_key => @pir_params[:secret_access_key])
    end
  
end