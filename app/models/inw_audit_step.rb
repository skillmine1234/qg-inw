class InwAuditStep < ActiveRecord::Base
  belongs_to :inw_auditable, :polymorphic => true
end
