defmodule LifeCoachApi.Accounts.Sms do 
   
    # @way2sms_url https://www.way2sms.com/api/v1/sendCampaign
    # @api_key 4MF5W989QZSJRKEBXV0KR2CEHSYPL61Y
    # @secret TBP1BSFF4IYA0MXX
    # @use_type prod
    # @senderId DCYBIT

    def send_sms(mobile_number, message) do
        params = body(mobile_number, message)
        HTTPoison.post "http://www.way2sms.com/api/v1/sendCampaign", Poison.encode!(params), [{"Content-Type", "application/json"}]  
    end

    def body(mobile_number, message) do 
            %{
                "apikey": "4MF5W989QZSJRKEBXV0KR2CEHSYPL61Y",
                "secret": "TBP1BSFF4IYA0MXX", 
                "usetype": "prod",
                "phone": mobile_number, 
                "message": message,
                "senderid": "DCYBIT"
            }
    end
end