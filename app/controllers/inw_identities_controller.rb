require 'will_paginate/array'

class InwIdentitiesController < ApplicationController
  load_and_authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include ApplicationHelper

end