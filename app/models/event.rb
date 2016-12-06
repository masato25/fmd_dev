class Event < ApplicationRecord
  establish_connection :development_falcon_portal
end
