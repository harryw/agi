module DatabaseClientsHelper
  def find_database_in_agi(name)
    Database.find_by_name(name)
  end
end