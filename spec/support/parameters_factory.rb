module Factories
  def self.parameters
    {
      'vend_site_id'  => ENV['VEND_SITE_ID'],
      'vend_user'     => ENV['VEND_USER'],
      'vend_password' => ENV['VEND_PASSWORD'],
    }
  end
end
