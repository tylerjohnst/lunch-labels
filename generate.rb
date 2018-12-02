require 'yaml'
require 'google/apis/sheets_v4'
require 'csv'
require 'prawn/labels'

Prawn::Labels.types = './avery.yml'

SECRETS = YAML.load(File.read(File.join(__dir__, 'secrets.yml')))
SHEET_ID = SECRETS['sheet_id']

$service = Google::Apis::SheetsV4::SheetsService.new
$service.key = SECRETS['google_key']

#
# Food
#

$food = $service.get_spreadsheet_values(SHEET_ID, 'Food').values[1..-1].map do |row|
  count, *rest = row
  Array.new(count.to_i, rest)
end.flatten(1)

Prawn::Labels.generate(File.expand_path("~/Desktop/food.pdf"), $food, type: 'Avery5160') do |pdf, row|
  name, carbs, protein, fat, calories = row
  pdf.stroke_bounds
  pdf.move_down 10
  pdf.font File.join(__dir__, '/SignPainter.ttf') do
    pdf.text "Low Carb Lunch Lady", align: :center, size: 20
  end

  pdf.text name + "\n" +
           "#{calories}: #{fat}g/#{carbs}g/#{protein}g",
           align: :center
end

#
# Customers
#

$customers = $service.get_spreadsheet_values(SHEET_ID, 'customers').values[1..-1].map do |row|
  count, *rest = row
  Array.new(count.to_i, rest)
end.flatten(1)

Prawn::Labels.generate(File.expand_path("~/Desktop/customers.pdf"), $customers, type: 'Avery8167') do |pdf, row|
  pdf.stroke_bounds
  pdf.text "\n" + row.reverse.join(' '), align: :center, style: :bold
end
