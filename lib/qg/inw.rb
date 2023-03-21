require "qg/inw/engine"

module Qg
  module Inw
    NAME = "INW"
    GROUP = "inward-remittance"
    MENU_ITEMS = [:partner, :purpose_code, :bank,  :whitelisted_identity, 
    			  :inw_guideline, :partner_lcy_rate, :inward_remittance,
    			  :indivisual_rule,:inw_corporates_rule,:inw_beneficiaries_rules]
    MODELS = ["Partner", "Bank", "PurposeCode", "WhitelistedIdentity", "InwIdentity",
    		  "InwardRemittance", "InwRemittanceRule", "IncomingFile", "InwGuideline",
    		   "PartnerLcyRate","IndivisualRule","InwCorporatesRule","InwBeneficiariesRules"]
    COMMON_MENU_ITEMS = [:approval_worklist,:tokenization]
    TEST_MENU_ITEMS = []
    RULE = :inw_remittance_rule
  end
end
