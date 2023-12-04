module IndivisualRulesHelper
	def find_indivisual_rules(params)
	indivisual_rule = (params[:approval_status].present? and params[:approval_status] == 'U') ? IndivisualRule.unscoped : IndivisualRule
    indivisual_rule = indivisual_rule.where("LOWER(individuals) LIKE ?", "%#{params[:individuals].downcase}%") if params[:individuals].present?
	end
end
