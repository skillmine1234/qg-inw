class PurposeCodeSearcher < Searcher
  attr_searchable :page, :approval_status, :code, :is_enabled
  
  as_enum :is_enabled, [:Y, :N], map: :string, source: :is_enabled
  reln = reln.where("partner_lcy_rates.partner_code LIKE ?", "#{partner_code}%") if partner_code.presenr?

  def find
    reln = PurposeCode.order('id desc')
    reln = reln.where("purpose_codes.code LIKE ?", "#{code}%") if code.present?
    reln = reln.where("purpose_codes.is is_enabled LIKE ?", "#{is_enabled}%") if is_enabled.present?
    reln

  end
end