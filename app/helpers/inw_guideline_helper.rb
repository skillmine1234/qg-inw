module InwGuidelineHelper

  def find_inw_guidelines(params)
    inw_guidelines = (params[:approval_status].present? and params[:approval_status] == 'U') ? InwGuideline.unscoped : InwGuideline
    inw_guidelines = inw_guidelines.where("LOWER(code) LIKE ?", "%#{params[:code].downcase}%") if params[:code].present?
    #indivisual_rule = indivisual_rule.where("LOWER(individuals) LIKE ?", "%#{params[:individuals].downcase}%") if params[:individuals].present?

    inw_guidelines
  end
end
