require 'spec_helper'

describe PartnerHelper do
  include HelperMethods

  before(:each) do
    mock_ldap
  end

  context 'find_partner'do
    it 'should return partners' do
      partner = Factory(:partner,:enabled => 'Y', :approval_status => 'A')
      find_partners({:enabled => 'Y'}).should == [partner]
      find_partners({:enabled => 'N'}).should == []
      partner = Factory(:partner,:code => '1231111111', :approval_status => 'A')
      find_partners({:code => '1231111111'}).should == [partner]
      find_partners({:code => '3211111111'}).should == []  
      partner = Factory(:partner,:account_no => '1234567891', :approval_status => 'A')
      find_partners({:account_no => '1234567891'}).should == [partner]
      find_partners({:account_no => '3212434323'}).should == []     
    end

    it 'should return partners' do  
      fcr_customer1 = Factory(:fcr_customer, cod_cust_id: '2345', ref_phone_mobile: '2222222222', ref_cust_email: 'aaa@gmail.com')
      atom_customer1 = Factory(:atom_customer, customerid: '2345', mobileno: '2222222222', isactive: '1', accountno: '1234567890')
      
      fcr_customer2 = Factory(:fcr_customer, cod_cust_id: '6789', ref_phone_mobile: '2222222222', ref_cust_email: 'aaa@gmail.com')
      atom_customer2 = Factory(:atom_customer, customerid: '6789', mobileno: '2222222222', isactive: '1', accountno: '1234567890')

      partner = Factory(:partner, customer_id: '2345', :allow_neft => 'Y', :approval_status => 'A', account_no: '1234567890')
      find_partners({:allow_neft => 'Y'}).should == [partner]
      find_partners({:allow_neft => 'N'}).should == []  
      Partner.delete_all
      partner = Factory(:partner,:allow_rtgs => 'Y', :approval_status => 'A')
      find_partners({:allow_rtgs => 'Y'}).should == [partner]
      find_partners({:allow_rtgs => 'N'}).should == []  
      Partner.delete_all
      partner = Factory(:partner, customer_id: '6789',:allow_imps => 'Y', :approval_status => 'A', account_no: '1234567890')
      find_partners({:allow_imps => 'Y'}).should == [partner]
      find_partners({:allow_imps => 'N'}).should == []  
    end
  end 
end