require 'spec_helper'

describe PartnerLcyRateHelper do
  include HelperMethods

  before(:each) do
    mock_ldap
  end

  context 'find_partner_lcy_rate'do
    it 'should return partner_lcy_rates' do
      partner_lcy_rate = Factory(:partner_lcy_rate,:partner_code => '1231111111', :approval_status => 'A')
      find_partner_lcy_rates({:code => '1231111111'}).should == [partner_lcy_rate]
      find_partner_lcy_rates({:code => '3211111111'}).should == []      
    end
  end 
end