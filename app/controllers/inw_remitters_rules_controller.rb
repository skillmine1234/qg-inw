require 'will_paginate/array'

class InwRemittersRulesController < ApplicationController
	authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper

  def new
    @inw_remitters_rule = InwRemittersRule.new
  end

  def create
    @inw_remitters_rule = InwRemittersRule.new(remitter_rule_params)
    if !@inw_remitters_rule.valid?
      render "new"
    else
      @inw_remitters_rule.created_by = current_user.id
      @inw_remitters_rule.save!
      flash[:alert] = 'Inw Remitters Rule successfully created and is pending for approval'
      redirect_to @inw_remitters_rule
    end
  end

  def update
    @inw_remitters_rule = InwRemittersRule.unscoped.find_by_id(params[:id])
    @inw_remitters_rule.attributes = remitter_rule_params
    if !@inw_remitters_rule.valid?
      render "edit"
    else
      @inw_remitters_rule.updated_by = current_user.id
      @inw_remitters_rule.save!
      flash[:alert] = 'Inw Remitters Rule successfully modified and is pending for approval'
      redirect_to @inw_remitters_rule
    end
    rescue ActiveRecord::StaleObjectError
      @inw_corporates_rule.reload
      flash[:alert] = 'Someone edited the Inw Remitters Rule the same time you did. Please re-apply your changes to the InwRemitterssRule.'
      render "edit"
  end 

  def show
    @inw_remitters_rule = InwRemittersRule.unscoped.find_by_id(params[:id])
  end

  def index
    @inw_remitters_rules ||= InwRemittersRule.order("id desc").paginate(:per_page => 10, :page => params[:page])
    @inw_remitters_rule = @inw_remitters_rules.count
  end

  def audit_logs
    @inw_remitters_rule = InwRemittersRule.unscoped.find(params[:id]) rescue nil
    @audit = @inw_remitters_rule.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  private

  def remitter_rule_params
    params.require(:inw_remitters_rule).permit(:remitters,:created_by, :updated_by, :lock_version,
                                 :approved_id, :approved_version)
  end
end