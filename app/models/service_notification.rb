module ServiceNotification  
  extend ActiveSupport::Concern
  included do
    after_save :send_notification_on_approval
  end

  def send_notification_on_approval
    if approval_status == 'A' && last_action == 'C' && is_enabled == 'Y'
      notify_customer('Service Access Granted') unless Rails.env.test?
    elsif approval_status == 'A' && is_enabled == 'N' && is_enabled_was == 'Y'
      notify_customer('Service Access Removed') unless Rails.env.test?
    end
  rescue
    nil
  end

  def resend_setup
    notify = notify_customer('Service Access Granted')
    notify == true ? "Service setup has been resent succesfully!" : notify
  rescue OCIError, ArgumentError => e
    e.message
  end

  def notify_customer(event)
    event_id = ScEvent.find_by_event(event).try(:id)
    template = NsTemplate.find_by_sc_event_id_and_is_enabled(event_id,'Y') rescue nil
    user = IamCustUser.find_by(username: identity_user_id)
    if !template.nil? && !user.nil?
      plsql.pk_qg_send_email.enqueue1(ENV['CONFIG_IIB_SMTP_BROKER_UUID'], user.email, NsTemplate.render_template(template.email_subject, template_variables), NsTemplate.render_template(template.email_body, template_variables)) unless template.email_body.to_s.empty?
      plsql.pk_qg_send_sms.enqueue(ENV['CONFIG_IIB_SMTP_BROKER_UUID'], user.mobile_no, NsTemplate.render_template(template.sms_text, template_variables)) unless template.sms_text.to_s.empty?
      update_column(:notification_sent_at, Time.zone.now) if !template.email_body.to_s.empty? || !template.sms_text.to_s.empty?
      return true
    elsif template.nil?
      'Template is not setup for SMS / Email'
    else
      'User not available'
    end
  end

  def enable_resend_button?
    approval_status == 'A' ? true: false
  end
end