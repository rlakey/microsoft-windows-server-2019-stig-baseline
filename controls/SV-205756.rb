# encoding: UTF-8

control 'SV-205756' do
  title "Windows Server 2019 Create symbolic links user right must only be
assigned to the Administrators group."
  desc  "Inappropriate granting of user rights can provide system,
administrative, and other high-level capabilities.

    Accounts with the \"Create symbolic links\" user right can create pointers
to other objects, which could expose the system to attack.
  "
  desc  'rationale', ''
  desc  'check', "
    Verify the effective setting in Local Group Policy Editor.

    Run \"gpedit.msc\".

    Navigate to Local Computer Policy >> Computer Configuration >> Windows
Settings >> Security Settings >> Local Policies >> User Rights Assignment.

    If any accounts or groups other than the following are granted the \"Create
symbolic links\" user right, this is a finding:

    - Administrators

    For server core installations, run the following command:

    Secedit /Export /Areas User_Rights /cfg c:\\path\\filename.txt

    Review the text file.

    If any SIDs other than the following are granted the
\"SeCreateSymbolicLinkPrivilege\" user right, this is a finding:

    S-1-5-32-544 (Administrators)

    Systems that have the Hyper-V role will also have \"Virtual Machines\"
given this user right (this may be displayed as \"NT Virtual Machine\\Virtual
Machines\", SID S-1-5-83-0). This is not a finding.
  "
  desc  'fix', "
    Configure the policy value for Computer Configuration >> Windows Settings
>> Security Settings >> Local Policies >> User Rights Assignment >> \"Create
symbolic links\" to include only the following accounts or groups:

    - Administrators

    Systems that have the Hyper-V role will also have \"Virtual Machines\"
given this user right. If this needs to be added manually, enter it as \"NT
Virtual Machine\\Virtual Machines\".
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000324-GPOS-00125'
  tag gid: 'V-205756'
  tag rid: 'SV-205756r569188_rule'
  tag stig_id: 'WN19-UR-000090'
  tag fix_id: 'F-6021r355187_fix'
  tag cci: ['CCI-002235']
  tag legacy: ['SV-103151', 'V-93063']
  tag nist: ['AC-6 (10)']

  os_type = command('Test-Path "$env:windir\explorer.exe"').stdout.strip

  if os_type == 'False'
    describe 'This system is a Server Core Installation, and a manual check will need to be performed with command Secedit /Export /Areas User_Rights /cfg c:\\path\\filename.txt' do
      skip 'This system is a Server Core Installation, and a manual check will need to be performed with command Secedit /Export /Areas User_Rights /cfg c:\\path\\filename.txt'
    end
  else
    describe security_policy do
      its('SeCreateSymbolicLinkPrivilege') { should eq ['S-1-5-32-544'] }
    end
  end

end
