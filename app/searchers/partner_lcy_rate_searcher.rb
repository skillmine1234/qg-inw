class PartnerLcyRateSearcher < Searcher
  attr_searchable :page, :approval_status, :partner_code

  def find
    reln = PartnerLcyRateSearcher.order('id desc')
    reln = reln.where("partner_lcy_rates.partner_code LIKE ?", "#{partner_code}%") if partner_code.present?
    reln
  end

end