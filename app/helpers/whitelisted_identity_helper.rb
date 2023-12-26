module WhitelistedIdentityHelper	

	def find_whitelisted_identities(params)
    whitelisted_identities = (params[:approval_status].present? and params[:approval_status] == 'U') ? WhitelistedIdentity.unscoped.joins(:partner) : WhitelistedIdentity.joins(:partner)

        indivisual_rule = indivisual_rule.where("LOWER(individuals) LIKE ?", "%#{params[:individuals].downcase}%") if params[:individuals].present?

    whitelisted_identities = whitelisted_identities.where("LOWER(partners.code) LIKE ?", "%#{params[:partner_code]}%").split(",").collect(&:strip)) if params[:partner_code].present?
    whitelisted_identities = whitelisted_identities.where("LOWER(whitelisted_identities.full_name) LIKE ?", "%#{params[:name].downcase}%").split(",").collect(&:strip)) if params[:name].present?
    whitelisted_identities = whitelisted_identities.where("LOWER(rmtr_code) LIKE ?", "%#{params[:rmtr_code].downcase}%").split(",").collect(&:strip)) if params[:rmtr_code].present?
    whitelisted_identities = whitelisted_identities.where("LOWER(bene_account_no) LIKE ?", "%#{params[:bene_account_no].downcase}%").split(",").collect(&:strip)) if params[:bene_account_no].present?
    whitelisted_identities = whitelisted_identities.where("LOWER(bene_account_ifsc) LIKE ? ", "%#{params[:bene_account_ifsc].downcase}%").split(",").collect(&:strip)) if params[:bene_account_ifsc].present?
    whitelisted_identities
  end

end