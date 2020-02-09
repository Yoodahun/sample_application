
if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
        # Amazon S3의 설정
        :provider              => 'AWS',
        :region                => ENV['ap-northeast-1'],     # 例: 'ap-northeast-1'
        :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
        :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end