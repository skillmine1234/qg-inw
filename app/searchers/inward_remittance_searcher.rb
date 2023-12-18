class InwardRemittanceSearcher < Searcher
  attr_searchable :page, :partner_id, :status_code, :notify_status, :request_no, :rmtr_code, :bene_account_no, :bene_account_ifsc,
                  :bank_ref, :rmtr_full_name, :req_transfer_type, :transfer_type, :from_transfer_amount,
                  :to_transfer_amount, :from_req_timestamp, :to_req_timestamp, :wl_id, :wl_id_for
                  
  validate :validate_search_criteria
  
  as_enum :status_code, [:ONHOLD, :SENT_TO_BENEFICIARY, :COMPLETED, :FAILED], map: :string, source: :status_code
  as_enum :notify_status, [:'PENDING NOTIFICATION', :'NOTIFIED:REJECTED', :"NOTIFIED:OK", :'NOTIFICATION FAILED'], map: :string, source: :notify_status
  as_enum :req_transfer_type, [:NEFT, :IMPS, :RTGS, :FT], map: :string, source: :req_transfer_type
  as_enum :transfer_type, [:NEFT, :IMPS, :RTGS, :FT], map: :string, source: :transfer_type
  TRANSFERTYPE = [:NEFT, :IMPS, :RTGS, :FT, :UPI]


  def find
    reln = InwardRemittance.order('id desc')
    reln = reln.where("inward_remittances.request_no LIKE ?", "#{request_no}%") if request_no.present?
    reln = reln.where("inward_remittances.rmtr_code?", "#{rmtr_code}%") if rmtr_code.present?
    reln = reln.where("inward_remittances.:bene_account_no LIKE ?", "#{:bene_account_no}%") if bene_account_no.present?
    reln = reln.where("inward_remittances.bene_account_ifsc LIKE ?", "#{bene_account_ifsc}%") if bene_account_ifsc.present?
    reln = reln.where("inward_remittances.bank_ref LIKE ?", "#{bank_ref}%") if bank_ref.present?
    reln = reln.where("inward_remittances.rmtr_full_name LIKE ?", "#{rrmtr_full_name}%") if rmtr_full_name.present?
    reln = reln.where("inward_remittances.req_transfer_type LIKE ?", "#{req_transfer_type}%") if req_transfer_type.present?
    reln = reln.where("inward_remittances.transfer_type LIKE ?", "#{transfer_type}%") if transfer_type.present?
    reln = reln.where("inward_remittances.from_transfer_amount LIKE ?", "#{from_transfer_amount}%") if request_no.present?
    reln = reln.where("inward_remittances.rmtr_wl_id=?", wl_id.to_i) if wl_id.present? && wl_id_for == 'R'
    reln = reln.where("inward_remittances.bene_wl_id=?", wl_id.to_i) if wl_id.present? && wl_id_for == 'B'
    reln = reln.where("lower(inward_remittances.partner_code) LIKE ?", "#{partner_id.downcase}%") if partner_id.present?
    reln = reln.where("transfer_amount >= ? and transfer_amount <= ?", from_transfer_amount, to_transfer_amount) if from_transfer_amount.present? and to_transfer_amount.present?
    reln = reln.where("req_timestamp >= ? and req_timestamp <= ?", Time.zone.parse(from_req_timestamp).beginning_of_day,Time.zone.parse(to_req_timestamp).beginning_of_day) if from_req_timestamp.present? and to_req_timestamp.present?
    reln
  end
  
  private
  
  def validate_search_criteria
    if partner_id.blank? && attributes.any?{ |key| send(key.to_s).present? if ( key.to_s != "page")}
      errors.add(:partner_id, "Partner Code is mandatory")
    end
  end
  
  
end