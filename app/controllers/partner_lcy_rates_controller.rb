require 'will_paginate/array'

class PartnerLcyRatesController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper
  include PartnerLcyRateHelper


  def create
    @partner_lcy_rate = PartnerLcyRate.new(params[:partner_lcy_rate])
    if !@partner_lcy_rate.valid?
      render "edit"
    else
      @partner_lcy_rate.created_by = current_user.id
      @partner_lcy_rate.save!

      flash[:alert] = 'Partner Lcy Rate successfully created and is pending for approval'
      redirect_to @partner_lcy_rate
    end
  end

  def update
    @partner_lcy_rate = PartnerLcyRate.unscoped.find_by_id(params[:id])
    @partner_lcy_rate.attributes = params[:partner_lcy_rate]
    if !@partner_lcy_rate.valid?
      render "edit"
    else
      @partner_lcy_rate.updated_by = current_user.id
      @partner_lcy_rate.save!
      flash[:alert] = 'Partner Lcy Rate successfully modified and is pending for approval'
      redirect_to @partner_lcy_rate
    end
    rescue ActiveRecord::StaleObjectError
      @partner_lcy_rate.reload
      flash[:alert] = 'Someone edited the partner_lcy_rate the same time you did. Please re-apply your changes to the partner_lcy_rate.'
      render "edit"
  end 

  def show
    @partner_lcy_rate = PartnerLcyRate.unscoped.find_by_id(params[:id])
  end

  def index
    if params[:advanced_search].present?
      @partner_lcy_rates = find_partner_lcy_rates(params).order("id desc").paginate(:per_page => 10, :page => params[:page])
    else
      @partner_lcy_rates ||= PartnerLcyRate.order("id desc").paginate(:per_page => 10, :page => params[:page])
    end
    @partner_lcy_rates_count = @partner_lcy_rates.count
  end

  def audit_logs
    @partner_lcy_rate = PartnerLcyRate.unscoped.find(params[:id]) rescue nil
    @audit = @partner_lcy_rate.audits[params[:version_id].to_i] rescue nil
  end
  
  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  private

  def partner_lcy_rate_params
    params.require(:partner_lcy_rate).permit(:partner_code, :created_by, :updated_by, :approved_id, :approved_version, 
                                             :created_at, :updated_at, :lock_version, :rate, :approval_status)
  end
end