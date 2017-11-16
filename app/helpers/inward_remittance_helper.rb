module InwardRemittanceHelper
  def find_logs(params,transaction)
    if params[:step_name] != 'ALL'
      transaction.audit_steps.where('step_name=?',params[:step_name]).order("attempt_no desc") rescue []
    else
      transaction.audit_steps.order("id desc") rescue []
    end      
  end
  
  def link_to_whitelisted_identity_path(inward_remittance, party)
    wl_id = inward_remittance.send("#{party}_wl_id")
    if wl_id.nil?
      if inward_remittance.send("#{party}_needs_wl") == 'Y'
        if inward_remittance.partner.will_send_id == 'Y'
          if party == 'rmtr' && inward_remittance.rmtr_identity_count > 0
            return link_to 'Required : Add', new_whitelisted_identity_path(id_id: inward_remittance.remitter_identities.first, id_for: party[0].upcase)
          end
          if party == 'bene' && inward_remittance.bene_identity_count > 0
            return link_to 'Required : Add', new_whitelisted_identity_path(id_id: inward_remittance.beneficiary_identities.first, id_for: party[0].upcase)
          end
        end
        # the partner will send id but didnt send any, or the partner doesnt send the id at all
        link_to 'Required : Add', new_whitelisted_identity_path(inw_id: inward_remittance.id, id_for: party[0].upcase)
      else
        '-'
      end
    else
      link_to 'show', whitelisted_identity_path(wl_id)
    end
  end
end