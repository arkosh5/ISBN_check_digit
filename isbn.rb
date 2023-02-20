require 'sinatra'
require 'json'

MULTIPLIERS = [1, 3]

set :server, :puma

get '/calculate_isbn13_check_digit/:isbn' do
  isbn = params[:isbn]
  result = calculate_isbn_13_check_digit(isbn)
  {isbn: isbn, check_digit: result[-1]}.to_json
end

def calculate_isbn_13_check_digit(isbn)
  isbn = isbn.to_s.delete('^0-9')
  raise ArgumentError, 'Invalid ISBN13: must be 12 digits long' unless isbn.size == 12
  raise ArgumentError, 'Invalid ISBN13: input contains non-digit characters' if isbn.match(/\D/)

  sum = 0
  isbn.each_char.with_index do |digit, i|
    multiplier = MULTIPLIERS[i.even? ? 0 : 1]
    sum += digit.to_i * multiplier
  end

  check_digit = 10 - (sum % 10)
  check_digit = case check_digit
                when 10 then 0
                else check_digit
                end

  "#{isbn}#{check_digit}"
end
