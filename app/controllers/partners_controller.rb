require 'will_paginate/array'

class PartnersController < ApplicationController
  authorize_resource
  before_filter :authenticate_user!
  before_filter :block_inactive_user!
  respond_to :json
  include Approval2::ControllerAdditions
  include ApplicationHelper
  include PartnerHelper

  def new
    @partner = Partner.new
  end

  def create
    @partner = Partner.new(params[:partner])
    if !@partner.valid?
      render "new"
    else
      @partner.created_by = current_user.id
      @partner.save!

      flash[:alert] = 'Partner successfully created and is pending for approval'
      redirect_to @partner
    end
  end

  def update
    @partner = Partner.unscoped.find_by_id(params[:id])
    @partner.attributes = params[:partner]
    if !@partner.valid?
      render "edit"
    else
      @partner.updated_by = current_user.id
      @partner.save!
      flash[:alert] = 'Partner successfully modified and is pending for approval'
      redirect_to @partner
    end
    rescue ActiveRecord::StaleObjectError
      @partner.reload
      flash[:alert] = 'Someone edited the partner the same time you did. Please re-apply your changes to the partner.'
      render "edit"
  end 

  def show
    @partner = Partner.unscoped.find_by_id(params[:id])
  end

  def index
    if params[:advanced_search].present?
      @partners = find_partners(params).order("id desc")
    else
      @partners ||= Partner.order("id desc")
    end
    @partners = @partners.paginate(:per_page => 10, :page => params[:page])
    @partners_count = @partners.count
  end

  def audit_logs
    @partner = Partner.unscoped.find(params[:id]) rescue nil
    @audit = @partner.audits[params[:version_id].to_i] rescue nil
  end
  
  def approve
    redirect_to unapproved_records_path(group_name: 'inward-remittance')
  end

  def resend_notification
    @partner = Partner.find(params[:id]) rescue nil
    flash[:alert] = @partner.resend_setup
    redirect_to @partner
  end

  private

  def partner_params
    params.require(:partner).permit(:account_ifsc, :account_no, :allow_imps, :allow_neft, :allow_rtgs, 
                                    :beneficiary_email_allowed, :beneficiary_sms_allowed, :code, :created_by, 
                                    :identity_user_id, :low_balance_alert_at, :name, :ops_email_id, 
                                    :remitter_email_allowed, :remitter_sms_allowed, :tech_email_id, 
                                    :txn_hold_period_days, :updated_by, :lock_version, :enabled, :customer_id,
                                    :country, :address_line1, :address_line2, :address_line3,:mmid, :mobile_no,
                                    :add_req_ref_in_rep, :add_transfer_amt_in_rep, :approved_id, :approved_version,
                                    :notify_on_status_change, :app_code, :service_name, :guideline_id, :will_whitelist,
                                    :will_send_id, :hold_for_whitelisting, :hold_period_days, :auto_match_rule,
                                    :notification_sent_at, :auto_reschdl_to_next_wrk_day)
  end
end