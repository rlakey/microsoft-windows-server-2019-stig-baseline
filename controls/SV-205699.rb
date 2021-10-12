# encoding: UTF-8

control 'SV-205699' do
  title 'Windows Server 2019 shared user accounts must not be permitted.'
  desc  "Shared accounts (accounts where two or more people log on with the
same user identification) do not provide adequate identification and
authentication. There is no way to provide for nonrepudiation or individual
accountability for system access and resource usage."
  desc  'rationale', ''
  desc  'check', "
    Determine whether any shared accounts exist. If no shared accounts exist,
this is NA.

    Shared accounts, such as required by an application, may be approved by the
organization.  This must be documented with the ISSO. Documentation must
include the reason for the account, who has access to the account, and how the
risk of using the shared account is mitigated to include monitoring account
activity.

    If unapproved shared accounts exist, this is a finding.
  "
  desc  'fix', "
    Remove unapproved shared accounts from the system.

    Document required shared accounts with the ISSO. Documentation must include
the reason for the account, who has access to the account, and how the risk of
using the shared account is mitigated to include monitoring account activity.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000104-GPOS-00051'
  tag gid: 'V-205699'
  tag rid: 'SV-205699r569188_rule'
  tag stig_id: 'WN19-00-000070'
  tag fix_id: 'F-5964r355016_fix'
  tag cci: ['CCI-000764']
  tag legacy: ['SV-103523', 'V-93437']
  tag nist: ['IA-2']

  describe 'This control needs to be checked manually' do
    skip 'Control not executed as this test is manual'
  end

end
