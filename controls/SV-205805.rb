# encoding: UTF-8

control 'SV-205805' do
  title "Windows Server 2019 default AutoRun behavior must be configured to
prevent AutoRun commands."
  desc  "Allowing AutoRun commands to execute may introduce malicious code to a
system. Configuring this setting prevents AutoRun commands from executing."
  desc  'rationale', ''
  desc  'check', "
    If the following registry value does not exist or is not configured as
specified, this is a finding:

    Registry Hive: HKEY_LOCAL_MACHINE
    Registry Path:
\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer\\

    Value Name: NoAutorun

    Type: REG_DWORD
    Value: 0x00000001 (1)
  "
  desc  'fix', "Configure the policy value for Computer Configuration >>
Administrative Templates >> Windows Components >> AutoPlay Policies >> \"Set
the default behavior for AutoRun\" to \"Enabled\" with \"Do not execute any
autorun commands\" selected."
  impact 0.7
  tag severity: 'high'
  tag gtitle: 'SRG-OS-000368-GPOS-00154'
  tag gid: 'V-205805'
  tag rid: 'SV-205805r569188_rule'
  tag stig_id: 'WN19-CC-000220'
  tag fix_id: 'F-6070r355778_fix'
  tag cci: ['CCI-001764']
  tag legacy: ['V-93375', 'SV-103461']
  tag nist: ['CM-7 (2)']

  describe registry_key('HKEY_LOCAL_MACHINE\\Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer') do
    it { should have_property 'NoAutorun' }
    its('NoAutorun') { should cmp == 1 }
  end

end
