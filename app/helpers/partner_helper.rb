module PartnerHelper
  def find_partners(params)
    partners = Partner
    partners = partners.where("enabled=?",params[:enabled]) if params[:enabled].present?
    partners = partners.where("code=?",params[:code]) if params[:code].present?
    partners = partners.where("account_no=?",params[:account_no]) if params[:account_no].present?
    partners = partners.where("allow_neft=?",params[:allow_neft]) if params[:allow_neft].present?
    partners = partners.where("allow_rtgs=?",params[:allow_rtgs]) if params[:allow_rtgs].present?
    partners = partners.where("allow_imps=?",params[:allow_imps]) if params[:allow_imps].present?
    partners
  end
end