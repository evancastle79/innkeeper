class Key < ActiveRecord::Base

  def self.unused_key  
    rem = ("00000".."99999").to_a - Key.find_by_sql("select key_actual from `keys`").map { |rec| rec.key_actual }  
    rem[rand(rem.size)]  
  end

end
