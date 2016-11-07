class User < ApplicationRecord
  establish_connection :development_uic
  self.table_name = "user"
end
