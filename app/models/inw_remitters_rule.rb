class InwRemittersRule < ActiveRecord::Base
	self.table_name = "inw_remitters_rules"
	include Approval2::ModelAdditions
	
	belongs_to :created_user, :foreign_key =>'created_by', :class_name => 'User'
  	belongs_to :updated_user, :foreign_key =>'updated_by', :class_name => 'User'

  	validates_format_of :remitters, :with => /\A\w[\w\-\(\)\s\r\n]*\z/, :allow_blank => true
end
