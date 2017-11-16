class WhitelistedIdentitySearcher
  include ActiveModel::Validations
  attr_accessor :page, :partner_code, :name, :rmtr_code, :bene_account_no, :bene_account_ifsc, :approval_status
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
      WhitelistedIdentity.none.paginate(per_page: PER_PAGE, page: page)
    end
  end

  private
  def validate_search_criteria
    if partner_code.blank? && (name.present? || rmtr_code.present? || bene_account_ifsc.present? || bene_account_no.present? )
      errors[:base] << "Partner code is mandatory when using advanced search"
    elsif partner_code.present?
      partner = Partner.find_by(code: partner_code)
      if partner.present? && partner.will_send_id == 'Y' && (rmtr_code.present? || bene_account_ifsc.present? || bene_account_no.present? )
        errors[:base] << "Search is not allowed on ID Detail (i.e., RemitterCode, Beneficiary Account No and Beneficiary IFSC) for this Partner since Will Send ID is not N"
      end
    end
  end
  
  def persisted?
    false
  end

  def find
    reln = approval_status == 'U' ? WhitelistedIdentity.joins(:partner).unscoped.where("approval_status =?",'U').order("whitelisted_identities.id desc") : WhitelistedIdentity.joins(:partner).order("whitelisted_identities.id desc")
    reln = reln.where("partners.code=?", partner_code) if partner_code.present?
    reln = reln.where("whitelisted_identities.full_name=?", name) if name.present?
    reln = reln.where("whitelisted_identities.rmtr_code=?", rmtr_code) if rmtr_code.present?
    reln = reln.where("whitelisted_identities.bene_account_no=?", bene_account_no) if bene_account_no.present?
    reln = reln.where("whitelisted_identities.bene_account_ifsc=?", bene_account_ifsc) if bene_account_ifsc.present?
    reln
  end
end
