module PartnerHelper	

	def find_partners(params)
    partners = (params[:approval_status].present? and params[:approval_status] == 'U') ? Partner.unscoped : Partner
    partners = partners.where("LOWER(enabled) LIKE ?", "%#{params[:enabled]}%") if params[:enabled].present?
    partners = partners.where("LOWER(code) LIKE ?", "%#{params[:code]}%").split(",").collect(&:strip)) if params[:code].present?
    partners = partners.where("LOWER(account_no) ?", "%#{params[:account_no]}%").split(",").collect(&:strip)) if params[:account_no].present?
    partners = partners.where("LOWER(allow_neft) ?", "%#{params[:allow_neft]}%") if params[:allow_neft].present?
    partners = partners.where("LOWER(allow_rtgs) ?", "%#{params[:rtgs_allow]}%") if params[:rtgs_allow].present?
    partners = partners.where("LOWER(allow_imps) ?", "%#{params[:imps_allow]}%") if params[:imps_allow].present?
    partners
  end

end