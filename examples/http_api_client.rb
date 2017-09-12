module ServiceAPI
  InvalidToken = Class.new(StandardError)
  UnknownContact = Class.new(StandardError)

  module Client
    REQUEST_PATH = Rails.application.secrets.service_api_url + '/api/v2'
    MAX_PER_PAGE = 100

    def contacts(page: 1, per: MAX_PER_PAGE)
      fail InvalidToken, 'Please provide valid token.' if service_api_token.blank?
      url = REQUEST_PATH + '/contacts?' + { token: service_api_token, page: page, per: per }.to_query
      JSON(RestClient.get url, header: { content_type: :json })
    rescue RestClient::Unauthorized => error
      fail InvalidToken, 'Please provide valid token.'
    end

    def send_message(composition)
      fail InvalidToken, 'Please provide valid token.' if service_api_token.blank?
      url = REQUEST_PATH + '/messages?' + { token: service_api_token }.to_query
      RestClient.post(url, composition.to_json, { content_type: :json, accept: :json }).body
    rescue RestClient::UnprocessableEntity, RestClient::NotFound => error
      fail UnknownContact, 'Contact not recognized.'
    rescue RestClient::Unauthorized => error
      fail InvalidToken, 'Please provide valid token.'
    end
  end

  module MessageComposingRecipient
    def compose(body)
      fail UnknownContact, 'Contact not recognized.' if blank?
      {
        recipients: ["contact-#{self}"],
        message: { body: body }
      }
    end
  end
end

class SendsContactMessage < DCI::Context(:message, user: ServiceAPI::Client, to: ServiceAPI::MessageComposingRecipient)
  def call(message = @message)
    results = user.send_message to.compose(message)
    return :success, results
  rescue ServiceAPI::UnknownContact => error
    return :failure, message: error.message
  end
end
