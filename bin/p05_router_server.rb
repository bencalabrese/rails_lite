require 'rack'
require 'byebug'

require_relative '../lib/controller_base'
require_relative '../lib/router'

$counter = 0

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

class StatusesController < ControllerBase
  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params['cat_id'])
    end

    render_content(statuses.to_json, "application/json")
  end
end

class CatsController < ControllerBase
  def index
    if $counter == 0
      flash["errors"] = ["Testing flash messages"]
      flash.now["now_errors"] = ["testing now error"]
      session["test_token"] = "session_test"
    end

    $counter += 1
    # render_content($cats.to_json, "application/json")
    @cats = $cats
    @counter = $counter

    render :index
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
