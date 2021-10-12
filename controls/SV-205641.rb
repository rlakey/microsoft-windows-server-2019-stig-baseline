# encoding: UTF-8

control 'SV-205641' do
  title "Windows Server 2019 permissions for the Security event log must
prevent access by non-privileged accounts."
  desc  "Maintaining an audit trail of system activity logs can help identify
configuration errors, troubleshoot service disruptions, and analyze compromises
that have occurred, as well as detect attacks. Audit logs are necessary to
provide a trail of evidence in case the system or network is compromised. The
Security event log may disclose sensitive information or be susceptible to
tampering if proper permissions are not applied."
  desc  'rationale', ''
  desc  'check', "
    Navigate to the Security event log file.

    The default location is the \"%SystemRoot%\\System32\\winevt\\Logs\"
folder. However, the logs may have been moved to another folder.

    If the permissions for the \"Security.evtx\" file are not as restrictive as
the default permissions listed below, this is a finding:

    Eventlog - Full Control
    SYSTEM - Full Control
    Administrators - Full Control
  "
  desc  'fix', "
    Configure the permissions on the Security event log file (Security.evtx) to
prevent access by non-privileged accounts. The default permissions listed below
satisfy this requirement:

    Eventlog - Full Control
    SYSTEM - Full Control
    Administrators - Full Control

    The default location is the \"%SystemRoot%\\System32\\winevt\\Logs\" folder.

    If the location of the logs has been changed, when adding Eventlog to the
permissions, it must be entered as \"NT Service\\Eventlog\".
  "
  impact 0.5
  tag severity: 'medium'
  tag gtitle: 'SRG-OS-000057-GPOS-00027'
  tag satisfies: ['SRG-OS-000057-GPOS-00027', 'SRG-OS-000058-GPOS-00028', 'SRG-OS-000059-GPOS-00029']
  tag gid: 'V-205641'
  tag rid: 'SV-205641r569188_rule'
  tag stig_id: 'WN19-AU-000040'
  tag fix_id: 'F-5906r354842_fix'
  tag cci: ['CCI-000164', 'CCI-000163', 'CCI-000162']
  tag legacy: ['V-93191', 'SV-103279']
  tag nist: ['AU-9', 'AU-9', 'AU-9']

  get_system_root = command('Get-ChildItem Env: | Findstr SystemRoot').stdout.strip
  system_root = get_system_root[11..get_system_root.length]

  systemroot = system_root.strip

  winevt_logs_security = <<-EOH
  $output = (Get-Acl -Path #{systemroot}\\SYSTEM32\\WINEVT\\LOGS\\Security.evtx).AccessToString
  write-output $output
  EOH

  # raw powershell output
  raw_logs_security = powershell(winevt_logs_security).stdout.strip

  # clean results cleans up the extra line breaks
  clean_logs_security = raw_logs_security.lines.collect(&:strip)

  describe 'Verify the default registry permissions for the keys note below of the C:\Windows\System32\WINEVT\LOGS\Security.evtx' do
    subject { clean_logs_security }
    it { should cmp input('winevt_logs_security_perms') }
  end

end
