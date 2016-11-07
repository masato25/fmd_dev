class Host < ApplicationRecord
  establish_connection :development_boss
end
