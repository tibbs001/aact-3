require 'uri'
require 'net/http'
require 'vault'

def read_namespace_token(
  path = '/var/run/secrets/kubernetes.io/serviceaccount/token'
)
  File.open(path, 'r') { |f| f.read.chomp }
end

def use_developer_token
  puts "Trying developer token."
  token = ENV['VAULT_TOKEN']
  return false if token.blank?
  puts "Using developer token."
  token
end

def use_namespace_token(
  endpoint: ENV['VAULT_PROVIDER_URL'],
  fitz_endpoint: ENV['VAULT_FITZ_ENDPOINT'],
  namespace_token_path: ENV['VAULT_NAMESPACE_TOKEN_PATH'] || '/var/run/secrets/kubernetes.io/serviceaccount/token',
  role: ENV['VAULT_OKD_ROLE']
)
  puts "Trying namespace token."
  return false unless File.exists?(namespace_token_path)
  puts "Using namespace token."
  raise "Vault endpoint not specified. Please populate VAULT_PROVIDER_URL." if endpoint.blank?
  raise "Fitz endpoint not specified. Please populate VAULT_FITZ_ENDPOINT." if fitz_endpoint.blank?
  raise "Role not specified. Please populate VAULT_OKD_ROLE." if role.blank?

  auth_token_uri = URI("#{endpoint}/v1/auth/global/#{ENV['VAULT_FITZ_ENDPOINT']}/login")
  auth_token_request = Net::HTTP::Post.new(auth_token_uri)
  auth_token_request['Content-Type'] = 'application/json'
  auth_token_request.body = {
    jwt: read_namespace_token,
    role: ENV['VAULT_OKD_ROLE']
  }.to_json

  auth_token_response =
    Net::HTTP.start(
      auth_token_uri.hostname,
      auth_token_uri.port,
      use_ssl: true
    ) { |http| http.request(auth_token_request) }

  auth_token_data =
    JSON.parse(auth_token_response.body, symbolize_names: true)
  auth_token_data[:auth][:client_token]
end

def use_approle_token(
    role_id: ENV["VAULT_ROLE_ID"],
    secret_id: ENV["VAULT_SECRET_ID"]
)
    puts "Trying approle token."
    return false if role_id.blank?
    puts "Using approle token."
    raise "Secret ID missing. Please popluate VAULT_SECRET_ID" if secret_id.blank?
    approle_token_uri = URI("#{Vault.address}/v1/auth/ess-web/approle/login")
    approle_token_request = Net::HTTP::Post.new(approle_token_uri)
    approle_token_request['Content-Type'] = 'application/json'
    approle_token_request.body = {
      role_id: role_id,
      secret_id: secret_id
    }.to_json

    approle_token_response = Net::HTTP.start(approle_token_uri.hostname, approle_token_uri.port, use_ssl: true) do |http|
      http.request(approle_token_request)
    end

    approle_token_data =  JSON.parse(approle_token_response.body, symbolize_names: true)
    approle_token = approle_token_data[:auth][:client_token]

    approle_token
end

def main
  return
  if ENV["SKIP_VAULT"] == "true"
    puts "Skipping vault."
    return
  end

  puts "Loading secrets from vault"
  Vault.address = ENV["VAULT_PROVIDER_URL"]
  raise "Vault endpoint not specified. Please populate VAULT_PROVIDER_URL." if Vault.address.blank?

  Vault.token = use_namespace_token || use_approle_token || use_developer_token
  raise "Vault token not found." if Vault.token.blank?

  raise "Vault sealed: #{Vault.address}" if Vault.sys.seal_status.sealed?

  vault_secret_path = ENV["VAULT_SECRET_PATH"]
  raise "Secret path(s) not specified. Please populate VAULT_SECRET_PATH." if vault_secret_path.blank?

  secrets = vault_secret_path.split(",")
  # Prefix secrets with last segment of secret_name if specified
  prefix_secrets = ENV["VAULT_PREFIX_SECRETS"] == "true"

  secrets.each do |secret|
    if !Vault.logical.read(secret)
      puts "Vault secret not found"
      break
    end
    secret_data = Vault.logical.read(secret).data[:data]
    prefix = nil
    if prefix_secrets
      prefix = secret.split("/").last
    end
    secret_data.each do |name,value|
      secret_env_variable = [prefix, name].delete_if(&:blank?).join("_").upcase
      if !ENV[secret_env_variable].present?
        puts "Setting #{secret_env_variable}"
        ENV[secret_env_variable] = value.to_s
      else
        puts "#{secret_env_variable} already set"
      end
    end
  end
end

main
