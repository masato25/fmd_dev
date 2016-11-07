class Session < ApplicationRecord
  establish_connection :development_uic
  self.table_name = "session"
end
