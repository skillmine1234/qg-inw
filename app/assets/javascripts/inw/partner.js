$(document).ready(function(){
  if(!$('#partner_allow_imps').is(":checked")){
    $('#partner_mmid').prop('disabled',true);
    $('#partner_mobile_no').prop('disabled',true);
  }

  $("#partner_allow_imps").on("click", function () {
    if(!$('#partner_allow_imps').is(":checked")){
      $('#partner_mmid').val('');
      $('#partner_allow_imps').val('');
      $('#partner_mmid').prop('disabled',true);
      $('#partner_mobile_no').prop('disabled',true);
    }
    else{
      $('#partner_mmid').prop('disabled',false);
      $('#partner_mobile_no').prop('disabled',false);
    }
  });

  $("#partner_notify_on_status_change").on("click", function () {
    if(!$('#partner_notify_on_status_change').is(":checked")){
      $('#partner_app_code').val('');
      $('#partner_app_code').prop('readOnly',true);
    }
    else{
      $('#partner_app_code').prop('readOnly',false);     
    }
  });
  
  if(!$('#partner_will_whitelist').is(":checked") ) {
    $('#partner_hold_for_whitelisting').prop("checked",false);
    $('#partner_hold_for_whitelisting').prop('disabled',true);
    $('#partner_txn_hold_period_days').val(0);
    $('#partner_txn_hold_period_days').prop('readOnly',true);
    $('#partner_will_send_id').prop("checked",false);
    $('#partner_will_send_id').prop('disabled',true);
  }
  else {
    if ($('#partner_service_name').val() != 'INW2') {
      $('#partner_will_send_id').prop('disabled',false);
    }
    else {
      $('#partner_hold_for_whitelisting').prop('disabled',false);
      $('#partner_txn_hold_period_days').prop('readOnly',false);
      $('#partner_will_send_id').prop('disabled',false);
    }
  }
  
  $("#partner_will_whitelist").on("click", function () {
    if(!$('#partner_will_whitelist').is(":checked") ) {
      $('#partner_hold_for_whitelisting').prop("checked",false);
      $('#partner_hold_for_whitelisting').prop('disabled',true);
      $('#partner_txn_hold_period_days').val(0);
      $('#partner_txn_hold_period_days').prop('readOnly',true);
      $('#partner_will_send_id').prop("checked",false);
      $('#partner_will_send_id').prop('disabled',true);
    }
    else {
      if ($('#partner_service_name').val() != 'INW2') {
        $('#partner_will_send_id').prop('disabled',false);
      }
      else {
        $('#partner_hold_for_whitelisting').prop('disabled',false);
        $('#partner_txn_hold_period_days').prop('readOnly',false);
        $('#partner_will_send_id').prop('disabled',false);
      }
    }
  });
  
  if ($('#partner_service_name').val() == 'INW2'){
    if ($('#partner_will_whitelist').is(":checked")) {
      $('#partner_hold_for_whitelisting').prop('disabled',false);
      $('#partner_txn_hold_period_days').prop('readOnly',false);
      $('#partner_will_send_id').prop('disabled',false);
    }
    else {
      $('#partner_hold_for_whitelisting').prop("checked",false);
      $('#partner_txn_hold_period_days').val(0);
      $('#partner_will_send_id').prop("checked",false);
      $('#partner_hold_for_whitelisting').prop('disabled',true);
      $('#partner_txn_hold_period_days').prop('readOnly',true);
      $('#partner_will_send_id').prop('disabled',true);
    }
    $('#partner_remitter_sms_allowed').prop("checked",false);
    $('#partner_remitter_sms_allowed').prop('disabled',true);
    $('#partner_remitter_email_allowed').prop("checked",false);
    $('#partner_remitter_email_allowed').prop('disabled',true);
    $('#partner_auto_reschdl_to_next_wrk_day').prop('disabled',false);
  }
  else {
    if ($('#partner_will_whitelist').is(":checked")) {
      $('#partner_will_send_id').prop('disabled',false);
    }
    else {
      $('#partner_will_send_id').prop("checked",false);
      $('#partner_will_send_id').prop('disabled',true);
    }
    $('#partner_hold_for_whitelisting').prop("checked",false);
    $('#partner_txn_hold_period_days').val(0);
    $('#partner_hold_for_whitelisting').prop('disabled',true);
    $('#partner_txn_hold_period_days').prop('readOnly',true);
    $('#partner_remitter_sms_allowed').prop('disabled',false);
    $('#partner_remitter_email_allowed').prop('disabled',false);
    $('#partner_auto_reschdl_to_next_wrk_day').prop('checked',false);
    $('#partner_auto_reschdl_to_next_wrk_day').prop('disabled',true);
  }
  
  $("#partner_service_name").on("change", function () {
    if ($('#partner_service_name').val() == 'INW2'){
      if ($('#partner_will_whitelist').is(":checked")) {
        $('#partner_hold_for_whitelisting').prop('disabled',false);
        $('#partner_txn_hold_period_days').prop('readOnly',false);
        $('#partner_will_send_id').prop('disabled',false);
      }
      else {
        $('#partner_hold_for_whitelisting').prop("checked",false);
        $('#partner_txn_hold_period_days').val(0);
        $('#partner_will_send_id').prop("checked",false);
        $('#partner_hold_for_whitelisting').prop('disabled',true);
        $('#partner_txn_hold_period_days').prop('readOnly',true);
        $('#partner_will_send_id').prop('disabled',true);
      }
      $('#partner_remitter_sms_allowed').prop("checked",false);
      $('#partner_remitter_sms_allowed').prop('disabled',true);
      $('#partner_remitter_email_allowed').prop("checked",false);
      $('#partner_remitter_email_allowed').prop('disabled',true);
      $('#partner_auto_reschdl_to_next_wrk_day').prop('disabled',false);
    }
    else {
      if ($('#partner_will_whitelist').is(":checked")) {
        $('#partner_will_send_id').prop('disabled',false);
      }
      else {
        $('#partner_will_send_id').prop("checked",false);
        $('#partner_will_send_id').prop('disabled',true);
      }
      $('#partner_hold_for_whitelisting').prop("checked",false);
      $('#partner_txn_hold_period_days').val(0);
      $('#partner_hold_for_whitelisting').prop('disabled',true);
      $('#partner_txn_hold_period_days').prop('readOnly',true);
      $('#partner_remitter_sms_allowed').prop('disabled',false);
      $('#partner_remitter_email_allowed').prop('disabled',false);
      $('#partner_auto_reschdl_to_next_wrk_day').prop('checked',false);
      $('#partner_auto_reschdl_to_next_wrk_day').prop('disabled',true);
    }
  });
  
  $("#partner_hold_for_whitelisting").on("change", function () {
    if ($('#partner_hold_for_whitelisting').is(":checked")){
      $('#partner_txn_hold_period_days').prop('readOnly',false);
    }
    else {
      $('#partner_txn_hold_period_days').val(0);
      $('#partner_txn_hold_period_days').prop('readOnly',true);
    }
  });

  if ($('#partner_hold_for_whitelisting').is(":checked")){
    $('#partner_txn_hold_period_days').prop('readOnly',false);
  }
  else {
    $('#partner_txn_hold_period_days').val(0);
    $('#partner_txn_hold_period_days').prop('readOnly',true);
  }
});