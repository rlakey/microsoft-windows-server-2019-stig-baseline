# encoding: UTF-8

control 'SV-205883' do
  title "Windows Server 2019 Exploit Protection mitigations must be configured
for AcroRd32.exe."
  desc  "Exploit protection provides a means of enabling additional mitigations
against potential threats at the system and application level. Without these
additional application protections, Windows may be subject to various exploits."
  desc  'rationale', ''
  desc  'check', "
    If the referenced application is not installed on the system, this is NA.

    This is applicable to unclassified systems, for other systems this is NA.

    Run \"Windows PowerShell\" with elevated privileges (run as administrator).

    Enter \"Get-ProcessMitigation -Name AcroRd32.exe\".
    (Get-ProcessMitigation can be run without the -Name parameter to get a list
of all application mitigations configured.)

    If the following mitigations do not have a status of \"ON\", this is a
finding:

    DEP:
    Enable: ON

    ASLR:
    BottomUp: ON
    ForceRelocateImages: ON

    Payload:
    EnableExportAddressFilter: ON
    EnableExportAddressFilterPlus: ON
    EnableImportAddressFilter: ON
    EnableRopStackPivot: ON
    EnableRopCallerCheck: ON
    EnableRopSimExec: ON

    The PowerShell command produces a list of mitigations; only those with a
required status of \"ON\" are listed here.
  "
  desc  'fix', "
    Ensure the following mitigations are turned \"ON\" for AcroRd32.exe:

    DEP:
    Enable: ON

    ASLR:
    BottomUp: ON
    ForceRelocateImages: ON

    Payload:
    EnableExportAddressFilter: ON
    EnableExportAddressFilterPlus: ON
    EnableImportAddressFilter: ON
    EnableRopStackPivot: ON
    EnableRopCallerCheck: ON
    EnableRopSimExec: ON

    Application mitigations defined in the STIG are configured by a DoD EP XML
file included with the STIG package in the \"Supporting Files\" folder.

    The XML file is applied with the group policy setting Computer
Configuration >> Administrative Settings >> Windows Components >> Windows
Defender Exploit Guard >> Exploit Protection >> \"Use a common set of exploit
protection settings\" configured to \"Enabled\" with file name and location
defined under \"Options:\".  It is recommended the file be in a read-only
network location.
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000480-GPOS-00227'
  tag gid: 'V-205883'
  tag rid: 'SV-205883r569188_rule'
  tag stig_id: 'WN19-EP-000070'
  tag fix_id: 'F-6148r356012_fix'
  tag cci: ['CCI-000366']
  tag legacy: ['V-93323', 'SV-103411']
  tag nist: ['CM-6 b']

  acroRd32 = json({ command: "Get-ProcessMitigation -Name AcroRd32.exe | ConvertTo-Json" }).params

  if input('sensitive_system') == true || nil
    impact 0.0
    describe 'This Control is Not Applicable to sensitive systems.' do
      skip 'This Control is Not Applicable to sensitive systems.'
    end
  elsif acroRd32.empty?
    impact 0.0
    describe 'The referenced application is not installed on the system, this is NA.' do
      skip 'The referenced application is not installed on the system, this is NA.'
    end
  else
    describe "Exploit Protection: the following mitigations must be set to 'ON' for AcroRd32.exe" do
      subject { acroRd32 }
      its(['Dep','Enable']) { should eq 1 }
      its(['Aslr','BottomUp']) { should eq 1 }
      its(['Aslr','ForceRelocateImages']) { should eq 1 }
      its(['Payload','EnableExportAddressFilter']) { should eq 1 }
      its(['Payload','EnableExportAddressFilterPlus']) { should eq 1 }
      its(['Payload','EnableImportAddressFilter']) { should eq 1 }
      its(['Payload','EnableRopStackPivot']) { should eq 1 }
      its(['Payload','EnableRopCallerCheck']) { should eq 1 }
      its(['Payload','EnableRopSimExec']) { should eq 1 }
    end
  end

end
