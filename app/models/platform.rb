class Platform < ApplicationRecord
  establish_connection :development_boss
end
