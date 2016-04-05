require 'json'

class Flash
  # find the cookie for this app
  # deserialize the cookie into a hash
  attr_reader :now
  
  def initialize(req)
    cookie = req.cookies["_rails_lite_app_flash"]

    @cookie = {}
    @now = cookie ? JSON.parse(cookie) : {}
  end

  def [](key)
    @cookie.merge(@now)[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_flash(res)
    res.set_cookie(
      "_rails_lite_app_flash",
      path: "/",
      value: @cookie.to_json
    )
  end
end
