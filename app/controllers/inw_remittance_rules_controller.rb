require 'will_paginate/array'

class InwRemittanceRulesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper
  
  def new
    @rule = InwRemittanceRule.new
  end

  def create
    @rule = InwRemittanceRule.new(params[:inw_remittance_rule])
    if !@rule.valid?
      render "new"
    else
      @rule.created_by = current_user.id
      @rule.save
      flash[:alert] = 'Rule successfully created and is pending for approval'
      redirect_to @rule
    end
  end

  def update
    @rule = InwRemittanceRule.unscoped.find_by_id(params[:id])
    @rule.attributes = params[:inw_remittance_rule]
    if !@rule.valid?
      render "edit"
    else
      @rule.updated_by = current_user.id
      @rule.save
      flash[:alert] = 'Rule successfully modified and is pending for approval'
      redirect_to @rule
    end
    rescue ActiveRecord::StaleObjectError
      @rule.reload
      flash[:alert] = 'Someone edited the rule the same time you did. Please re-apply your changes to the rule.'
      render "edit"
  end

  def index
    @inw_remittance_rules_count = @inw_remittance_rules.count
  end

  def show
    @inw_remittance_rule = InwRemittanceRule.unscoped.find_by_id(params[:id])
  end

  def audit_logs
    @rule = InwRemittanceRule.unscoped.find(params[:id]) rescue nil
    @audit = @rule.audits[params[:version_id].to_i] rescue nil
  end

  def error_msg
    flash[:alert] = "Rule is not yet configured"
    redirect_to :root
  end
  
  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  private

  def inw_remittance_rule_params
    params.require(:inw_remittance_rule).permit(:pattern_individuals, :pattern_corporates, :pattern_beneficiaries, :created_by, 
                                 :updated_by, :lock_version, :pattern_salutations, :pattern_remitters, :approved_id, :approved_version)
  end
end