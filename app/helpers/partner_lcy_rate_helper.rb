module PartnerLcyRateHelper
  def find_partner_lcy_rates(params)
    partner_lcy_rates = PartnerLcyRate
    partner_lcy_rates = partner_lcy_rates.where("partner_code=?",params[:code]) if params[:code].present?
    partner_lcy_rates
  end
end