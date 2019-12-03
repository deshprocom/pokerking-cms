class IpLocation
  #  IpLocation.query('131.194.180.190')
  def self.query(ip)
    resp = Faraday.post "https://iplocation.com?ip=#{ip}"
    JSON.parse resp.body
  end
end