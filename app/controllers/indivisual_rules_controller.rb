require 'will_paginate/array'

class IndivisualRulesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper

  def new
    @indivisual_rule = IndivisualRule.new
  end

  def create
    @indivisual_rule = IndivisualRule.new(params[:indivisual_rule])
    if !@indivisual_rule.valid?
      render "new"
    else
      @indivisual_rule.created_by = current_user.id
      @indivisual_rule.save!
      flash[:alert] = 'IndivisualRule successfully created and is pending for approval'
      redirect_to @indivisual_rule
    end
  end

  def update
    @indivisual_rule = IndivisualRule.unscoped.find_by_id(params[:id])
    @indivisual_rule.attributes = params[:indivisual_rule]
    if !@indivisual_rule.valid?
      render "edit"
    else
      @indivisual_rule.updated_by = current_user.id
      @indivisual_rule.save!
      flash[:alert] = 'IndivisualRule successfully modified and is pending for approval'
      redirect_to @indivisual_rule
    end
    rescue ActiveRecord::StaleObjectError
      @indivisual_rule.reload
      flash[:alert] = 'Someone edited the IndivisualRule the same time you did. Please re-apply your changes to the IndivisualRule.'
      render "edit"
  end 

  def show
    @indivisual_rule = IndivisualRule.unscoped.find_by_id(params[:id])
  end

  def index
    @indivisual_rules ||= IndivisualRule.order("id desc").paginate(:per_page => 10, :page => params[:page])
    @indivisual_rule = @indivisual_rules.count
  end

  def audit_logs
    @indivisual_rule = IndivisualRule.unscoped.find(params[:id]) rescue nil
    @audit = @indivisual_rule.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  private

  def indivisual_rule_params
    params.require(:indivisual_rule).permit(:individuals,:created_by, :updated_by, :lock_version,
                                 :approved_id, :approved_version)
  end
end
