require 'net/http'
require 'uri'
require 'json'

CHALLENGE_URL = 'https://letsrevolutionizetesting.com/challenge.json'

def contains_prop(prop, json)
  json.key?(prop)
end

def get_prop(prop, json)
  json[prop]
end

def get_query_params(url)
  URI.parse(url).query
end

def make_request(challenge_id = nil)
  payload =  json_response =  message = nil

  if challenge_id
    payload = 'id' => challenge_id  end

  # make request
  uri = URI.parse(CHALLENGE_URL)
  uri.query = URI.encode_www_form(payload)
  response = Net::HTTP.get_response(uri)

  puts uri.to_s

  json_response = JSON.parse(response.body)

  if contains_prop('follow', json_response)
    follow = get_prop('follow', json_response)
    query_params = get_query_params(follow)
    id = query_params.split('=')[1]
    return make_request(challenge_id: id)
  elsif contains_prop('message', json_response)
    message = get_prop('message', json_response)
  end

  message
end

puts make_request(challenge_id: nil)
