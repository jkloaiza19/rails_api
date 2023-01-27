require 'net/http'
require 'uri'
require 'json'

module Firebase
  # It's a class that authenticates a user with Firebase and validates a token
  class AuthenticationManager
    FIREBASE_SIGNUP_URI = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{ENV['FIREBASE_API_KEY']}")
    FIREBASE_SIGNIN_URI = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{ENV['FIREBASE_API_KEY']}")
    FIREBASE_REFRESH_TOKEN_URI = URI("https://securetoken.googleapis.com/v1/token?key=#{ENV['FIREBASE_API_KEY']}")
    FIREBASE_PUBLIC_KEY_URL = URI('https://www.googleapis.com/robot/v1/metadata/x509/securetoken@system.gserviceaccount.com')
    JWT_ALGORITHM = 'RS256'.freeze

    class << self
      def signup(email, password)
        response = Net::HTTP.post_form(FIREBASE_SIGNUP_URI, email: email, password: password, returnSecureToken: true)

        JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
      end

      def signin(email, password)
        response = Net::HTTP.post_form(FIREBASE_SIGNIN_URI, email: email, password: password)

        JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
      end

      def refresh_token(token)
        response = Net::HTTP.post_form(FIREBASE_REFRESH_TOKEN_URI, refresh_token: token)

        JSON.parse(response.body) if response.is_a?(Net::HTTPSuccess)
      end

      def valid_token?(token)
        header = decode_header(token)
        alg = header['alg']
        kid = header['kid']

        public_key = public_key(kid)

        raise ExceptionErrors::InvalidToken.new(detail: "Invalid token alg header #{alg}") unless alg == JWT_ALGORITHM

        decoded_token = decode_token(token, public_key, ENV['FIREBASE_PROJECT_ID'])

        valid_token = token_active?(decoded_token.first['exp'])

        raise ExceptionErrors::InvalidToken.new(detail: 'Token is expired') unless valid_token

        valid_token
      end

      private

      def decode_header(token)
        encoded_header = token.split('.').first

        JSON.parse(Base64.decode64(encoded_header))
      end

      def public_key(kid)
        response = Net::HTTP.get(FIREBASE_PUBLIC_KEY_URL)

        raise StandardError, 'Failed to fetch JWT public keys from google' unless response.is_a?(String)

        public_keys = JSON.parse(response)

        raise ExceptionErrors::InvalidToken.new(detail: "Invalid token public key #{kid}") unless public_keys.include?(kid)

        OpenSSL::X509::Certificate.new(public_keys[kid]).public_key
      end

      def decode_token(token, public_key, firebase_project_id)
        options = {
          algorithm: JWT_ALGORITHM,
          verify_iat: true,
          verify_aud: true,
          aud: firebase_project_id,
          verify_iss: true,
          iss: "https://securetoken.google.com/#{firebase_project_id}"
        }

        JWT.decode(token, public_key, true, options)
      end

      def token_active?(exp)
        current_time = Time.at(DateTime.now).utc.localtime
        token_expiration_time = Time.at(exp).utc.localtime

        token_expiration_time > current_time
      end
    end
  end
end
