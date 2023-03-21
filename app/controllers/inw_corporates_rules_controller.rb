require 'will_paginate/array'

class InwCorporatesRulesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper

  def new
    @inw_corporates_rule = InwCorporatesRule.new
  end

  def create
    @inw_corporates_rule = InwCorporatesRule.new(params[:inw_corporates_rule])
    if !@inw_corporates_rule.valid?
      render "new"
    else
      @inw_corporates_rule.created_by = current_user.id
      @inw_corporates_rule.save!
      flash[:alert] = 'INW InwCorporates Rule successfully created and is pending for approval'
      redirect_to @inw_corporates_rule
    end
  end

  def update
    @inw_corporates_rule = InwCorporatesRule.unscoped.find_by_id(params[:id])
    @inw_corporates_rule.attributes = params[:inw_corporates_rule]
    if !@inw_corporates_rule.valid?
      render "edit"
    else
      @inw_corporates_rule.updated_by = current_user.id
      @inw_corporates_rule.save!
      flash[:alert] = 'Inw Corporates Rule successfully modified and is pending for approval'
      redirect_to @inw_corporates_rule
    end
    rescue ActiveRecord::StaleObjectError
      @inw_corporates_rule.reload
      flash[:alert] = 'Someone edited the Inw Corporates Rule the same time you did. Please re-apply your changes to the InwCorporatesRule.'
      render "edit"
  end 

  def show
    @inw_corporates_rule = InwCorporatesRule.unscoped.find_by_id(params[:id])
  end

  def index
    @inw_corporates_rules ||= InwCorporatesRule.order("id desc").paginate(:per_page => 10, :page => params[:page])
    @inw_corporates_rule = @inw_corporates_rule.count
  end

  def audit_logs
    @inw_corporates_rule = InwCorporatesRule.unscoped.find(params[:id]) rescue nil
    @audit = @inw_corporates_rule.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  private

  def corporate_rule_params
    params.require(:inw_corporates_rule).permit(:corporates,:created_by, :updated_by, :lock_version,
                                 :approved_id, :approved_version)
  end
end
