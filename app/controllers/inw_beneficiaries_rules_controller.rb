require 'will_paginate/array'

class InwBeneficiariesRulesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper

  def new
    @inw_beneficiaries_rule = InwBeneficiariesRules.new
  end

  def create
    @inw_beneficiaries_rule = InwBeneficiariesRules.new(params[:beneficiaries_rules])
    if !@inw_beneficiaries_rule.valid?
      render "new"
    else
      @inw_beneficiaries_rule.created_by = current_user.id
      @inw_beneficiaries_rule.save!
      flash[:alert] = 'Inw Beneficiaries Rules successfully created and is pending for approval'
      redirect_to @inw_beneficiaries_rule
    end
  end

  def update
    @inw_beneficiaries_rule = InwBeneficiariesRulesw.unscoped.find_by_id(params[:id])
    @inw_beneficiaries_rule.attributes = params[:beneficiaries_rules]
    if !@inw_beneficiaries_rule.valid?
      render "edit"
    else
      @inw_beneficiaries_rule.updated_by = current_user.id
      @inw_beneficiaries_rule.save!
      flash[:alert] = 'Inw Beneficiaries Rules successfully modified and is pending for approval'
      redirect_to @inw_beneficiaries_rule
    end
    rescue ActiveRecord::StaleObjectError
      @inw_beneficiaries_rule.reload
      flash[:alert] = 'Someone edited the Inw Beneficiaries Rules the same time you did. Please re-apply your changes to the Inw Beneficiaries Rules.'
      render "edit"
  end 

  def show
    @inw_beneficiaries_rule = InwBeneficiariesRules.unscoped.find_by_id(params[:id])
  end

  def index
    @inw_beneficiaries_rules ||= InwBeneficiariesRules.order("id desc").paginate(:per_page => 10, :page => params[:page])
    @inw_beneficiaries_rule = @inw_beneficiaries_rules.count
  end

  def audit_logs
    @inw_beneficiaries_rule = InwBeneficiariesRules.unscoped.find(params[:id]) rescue nil
    @audit = @inw_beneficiaries_rule.audits[params[:version_id].to_i] rescue nil
  end

  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  private

  def beneficiaries_rules_params
    params.require(:beneficiaries_rules).permit(:beneficiaries,:created_by, :updated_by, :lock_version,
                                 :approved_id, :approved_version)
  end
end
