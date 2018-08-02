require './config/environment'

use Rack::MethodOverride
use GimojisController
use UsersController
run ApplicationController
