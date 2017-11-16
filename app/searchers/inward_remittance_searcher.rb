class InwardRemittanceSearcher
  include ActiveModel::Validations
  attr_accessor :page, :partner_code, :status_code, :notify_status, :req_no, :bank_ref, :rmtr_full_name, :req_transfer_type, :transfer_type,
                :from_amount, :to_amount, :from_date, :to_date, :wl_id, :wl_id_for, :rmtr_code, :bene_account_no, :bene_account_ifsc
  PER_PAGE = 10
  
  validate :validate_search_criteria

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def paginate
    if valid? 
      find.paginate(per_page: PER_PAGE, page: page)
    else
      InwardRemittance.none.paginate(per_page: PER_PAGE, page: page)
    end
  end

  private
  def validate_search_criteria
    
    if partner_code.blank? && 
        ( status_code.present? || notify_status.present? || req_no.present? || 
          bank_ref.present? || rmtr_full_name.present? || 
          req_transfer_type.present? || transfer_type.present? || 
          from_amount.present? || to_amount.present? || from_date.present? || to_date.present? || 
          wl_id.present? || wl_id_for.present? || rmtr_code.present? || 
          bene_account_no.present? || bene_account_ifsc.present? 
        )
      errors[:base] << "Partner code is mandatory when using advanced search" 
    end
  end
  
  def persisted?
    false
  end

  def find
    reln = InwardRemittance.order("id desc")

    reln = reln.where("inward_remittances.status_code=?", status_code) if status_code.present?
    reln = reln.where("inward_remittances.notify_status=?", notify_status) if notify_status.present?
    reln = reln.where("inward_remittances.req_no LIKE ?", "#{req_no}%") if req_no.present?
    reln = reln.where("lower(inward_remittances.partner_code) LIKE ?", "#{partner_code.downcase}%") if partner_code.present?
    reln = reln.where("inward_remittances.bank_ref=?", bank_ref) if bank_ref.present?
    reln = reln.where("inward_remittances.rmtr_full_name=?", rmtr_full_name) if rmtr_full_name.present?
    reln = reln.where("inward_remittances.req_transfer_type=?", req_transfer_type) if req_transfer_type.present?
    reln = reln.where("inward_remittances.transfer_type=?", transfer_type) if transfer_type.present?
    reln = reln.where("inward_remittances.transfer_amount>=? and inward_remittances.transfer_amount <=?",from_amount.to_f, to_amount.to_f) if to_amount.present? && from_amount.present?
    reln = reln.where("inward_remittances.req_timestamp>=? and inward_remittances.req_timestamp<=?",Time.zone.parse(from_date).beginning_of_day,Time.zone.parse(to_date).end_of_day) if from_date.present? && to_date.present?
    reln = reln.where("inward_remittances.rmtr_wl_id=?", wl_id.to_i) if wl_id.present? && wl_id_for == 'R'
    reln = reln.where("inward_remittances.bene_wl_id=?", wl_id.to_i) if wl_id.present? && wl_id_for == 'B'
    reln = reln.where("inward_remittances.rmtr_code=?", rmtr_code) if rmtr_code.present?
    reln = reln.where("inward_remittances.bene_account_no=?", bene_account_no) if bene_account_no.present?
    reln = reln.where("inward_remittances.bene_account_ifsc=?", bene_account_ifsc) if bene_account_ifsc.present?

    reln
  end
end
