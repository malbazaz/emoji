require './config/environment'

use Rack::MethodOverride
use GimojisController
use UsersController
use EmotionsController
run ApplicationController
