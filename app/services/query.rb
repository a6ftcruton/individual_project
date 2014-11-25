require 'ostruct'

class Query
  attr_reader   :results,
                :first_address,
                :second_address,
                :queries, 
                :radius

  def initialize(params)
    @results        = OpenStruct.new
    @queries        = params["query"]
    @first_address  = params["first_address"]
    @second_address = params["second_address"] 
    @radius         = params["radius"].to_f
  end

  def start
    queries.keys.each do |query|
      results[query] = self.send(query)
    end
    results
  end

  def crime
    Crime.current_year.near(@first_address, radius.to_f)
  end

  def parks
    category_id = "4bf58dd8d48988d163941735"
    response = FourSquare.send_request(@first_address, radius_to_meters, category_id)["response"]
    response["venues"]
  end
  
  def grocers
    category_id = '4bf58dd8d48988d118951735'
    response = FourSquare.send_request(@first_address, radius_to_meters, category_id)["response"]
    response["venues"]
  end

  def libraries
    category_id = '4bf58dd8d48988d12f941735'
    response = FourSquare.send_request(@first_address, radius_to_meters, category_id)["response"]
    response["venues"]
  end
  
  def restaurants
    category_id = '4d4b7105d754a06374d81259'
    response = FourSquare.send_request(@first_address, radius_to_meters, category_id)["response"]
    response["venues"]
  end

  def radius_to_meters
    (radius.to_f * 1600).to_i
  end
  
end

class FourSquare
  include HTTParty 
  format :json

  base_uri 'https://api.foursquare.com/v2/venues'
  default_params client_id: ENV["FOURSQUARE_ID"], 
                 client_secret: ENV["FOURSQUARE_SECRET"],
                 output: 'json',
                 v: 20140806

  def self.send_request(address, radius, criteria)
    get("/search", query: { near: address, radius: radius, categoryId: criteria })
  end
  
end
