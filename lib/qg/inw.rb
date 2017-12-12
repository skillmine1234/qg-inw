require "qg/inw/engine"

module Qg
  module Inw
    NAME = "INW"
    GROUP = "inward-remittance"
    MENU_ITEMS = [:partner, :purpose_code, :bank,  :whitelisted_identity, :inw_guideline, :partner_lcy_rate]
    MODELS = ["Partner", "Bank", "PurposeCode", "WhitelistedIdentity", "InwIdentity", "InwardRemittance", "InwRemittanceRule", "IncomingFile", "InwGuideline", "PartnerLcyRate"]
    COMMON_MENU_ITEMS = [:incoming_file, :approval_worklist, :aml_search]
    TEST_MENU_ITEMS = []
    OPERATIONS = [:inward_remittance]
    RULE = :inw_remittance_rule
  end
end
