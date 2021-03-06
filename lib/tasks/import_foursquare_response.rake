require 'four_square'

namespace :import_foursquare_response do
  include FourSquare

  desc "Load database with results of API calls"
  task :create_records => :environment do
    puts "Loading database..."

    center = "2393 E Alameda Ave Denver CO" 
    radius = 12000
    result_count = 0

    Table = Struct.new(:table, :category_id)
    # eventually move the "tables" out into a constant or module
    tables = { 
      "Park": "4bf58dd8d48988d163941735",
      "GroceryStore": "4bf58dd8d48988d118951735",
      "Library": "4bf58dd8d48988d12f941735",
      "Restaurant": "4d4b7105d754a06374d81259",
      "Bar": "4bf58dd8d48988d11b941735,4bf58dd8d48988d121941735,4bf58dd8d48988d118941735",
      "CoffeeShop": "4bf58dd8d48988d1e0931735",
      "Museum": "4bf58dd8d48988d181941735",
      "LiquorStore": "4bf58dd8d48988d186941735",
      "Pharmacy": "4bf58dd8d48988d10f951735",
      "BusStop": "52f2ab2ebcbc57f1066b8b4f",
      "LightRailStop": "52f2ab2ebcbc57f1066b8b4f",
      "Theater": "4bf58dd8d48988d137941735,4bf58dd8d48988d135941735,4bf58dd8d48988d1ac941735",
      "Movie": "4bf58dd8d48988d17f941735",
      "LiveMusic": "4bf58dd8d48988d1e5931735",
      "ArtGallery": "4bf58dd8d48988d1e2931735",
      "HardwareStore": "4bf58dd8d48988d112951735"
    }

    def impose_struct(data)
      data.map { |k,v| Table.new(k, v) }
    end

    structured_tables = impose_struct(tables)
    structured_tables.each do |tbl|
      results = FourSquare.all_denver_results(center, radius, tbl.category_id)["response"]["venues"]
      results.each do |result|
        table_name = tbl.table.to_s.constantize
        table_name.find_or_create_by(
          name: result["name"],
          latitude: result["location"]["lat"].to_f,
          longitude: result["location"]["lng"].to_f
        )
      end
    end
#    category_id = "4bf58dd8d48988d163941735"
#    results = FourSquare.all_denver_results(center, radius, category_id)["response"]["venues"]
#
#    results.each do |result|
#      puts result_count += 1
#      puts result["name"]
#      Park.find_or_create_by(
#        name: result["name"],
#        latitude: result["location"]["lat"].to_f,
#        longitude: result["location"]["lng"].to_f
#      )
#    end
  end
end


# Next Steps:
# --------------------
# FourSquare.all_denver_results(table, category_id)["response"]["venues"]
#   table.find_or_creat_by <- where 'table' is the model name?
#
#   then create a rake task that runs for each model relying on these api calls
#
#   next: rewrite method being called in Query to return results from my database instead of from an API call
