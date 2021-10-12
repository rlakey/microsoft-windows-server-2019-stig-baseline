# encoding: UTF-8

control 'SV-205917' do
  title "Windows Server 2019 must prevent NTLM from falling back to a Null
session."
  desc  "NTLM sessions that are allowed to fall back to Null (unauthenticated)
sessions may gain unauthorized access."
  desc  'rationale', ''
  desc  'check', "
    If the following registry value does not exist or is not configured as
specified, this is a finding:

    Registry Hive: HKEY_LOCAL_MACHINE
    Registry Path: \\SYSTEM\\CurrentControlSet\\Control\\LSA\\MSV1_0\\

    Value Name: allownullsessionfallback

    Type: REG_DWORD
    Value: 0x00000000 (0)
  "
  desc  'fix', "Configure the policy value for Computer Configuration >>
Windows Settings >> Security Settings >> Local Policies >> Security Options >>
\"Network security: Allow LocalSystem NULL session fallback\" to \"Disabled\"."
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-205917'
  tag rid: 'SV-205917r569188_rule'
  tag stig_id: 'WN19-SO-000270'
  tag fix_id: 'F-6182r356114_fix'
  tag cci: ['CCI-000366']
  tag legacy: ['V-93297', 'SV-103385']
  tag nist: ['CM-6 b']

  describe registry_key('HKEY_LOCAL_MACHINE\\System\\CurrentControlSet\\Control\\Lsa\\MSV1_0') do
    it { should have_property 'allownullsessionfallback' }
    its('allownullsessionfallback') { should cmp == 0 }
  end 

end
