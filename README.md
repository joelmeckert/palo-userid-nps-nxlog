# palo-userid-nps-nxlog
- Set the Palo Alto User-ID based on Microsoft NPS RADIUS authentication via NXLog CE as a tail/syslog collector, User-ID Agent on a Windows server
- Create firewall rules based on User-ID or group
- Palo Alto User-ID with Microsoft NPS RADIUS, XML logs, and NXLog CE to tail the log
- Optionally, run a PowerShell script on a regular basis on the User-ID Agent Windows server to add Active Directory computers to the exclude list

# Installation
## Microsoft NPS/RADIUS
- Configure Microsoft NPS with the default XML logging, and the usual NPS configuration that is already in-place
## NXLog on NPS Host
- Install NXLog Community Edition
- Modify configuration file, copy to "C:\Program Files (x86)\nxlog\conf\nxlog.conf"
  - Replace NetBIOS domain name in configuration file with your NetBIOS domain
  - Regular expressions are used to parse and reconstruct the XML, so that it is under the required size and minimizes the data to the User-ID Agent
  - Extranneous entries are discarded rather than forwarded to the User-ID Agent, as per the regular expression(s) in the NXLog configuration file
## Palo Alto User-ID Agent Host
- Windows Firewall
  - Allow for TCP 514 for inbound syslog
  - TCP is used, as it supports a greater length of syslog packet, and is reliable, as firewall rules are based on User-ID
## Palo Alto User-ID Agent Installation
- Install User-ID Agent on a domain member server, not a domain controller
- RADIUS Connect, Syslog configuration, replace NBDOMAIN with NetBIOS domain
  - Event regex
  ```
  <Acct-Status-Type data_type="0">1<\/Acct-Status-Type>{1}
  ```
  - Username regex
  ```
  <User-Name\sdata_type="1">(NBDOMAIN\\[a-zA-z0-9\._-]{3,15})<\/User-Name>
  ```
  - Address regex
  ```
  <Framed-IP-Address\sdata_type="3">([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})<\/Framed-IP-Address>
  ```
- Access Control List => Syslog
  - Allow from IP address of NPS/RADIUS server
- User Identification Agent => Discovery
  - Name: Display name of NPS
  - Server: IP of NPS
  - Server Type: Syslog Sender
  - Default Domain Name: NetBIOS name of domain
  - Filters => RADIUS Connect, event type: Login
  - Filters => RADIUS Disconnect, event type: Logout

# Notes
- Session Log monitoring has a lot of noise, but it is noise that is better handled by a host that is running the User-ID Agent on Windows
- It is of ***utmost importantce*** to preserve the resources of the management plane on the firewall
- The configuration of the communication of the User-ID Agent is outside of the scope of this document, but Palo Alto has public documentation on this process
- Minimize User-ID traffic to the Palo Alto, ***protect the management plane!!!***
  - NXLog filters the syslog connections by regular expression
  - Filtered events with minimalistic data are submitted via syslog
  - Where implemented, the PowerShell script will obtain a list of computers in the domain and add them to the user exclusion file
  - Entries in the exclusion file are not submitted to the firewall, and lessen the load on the management plane
  - User-ID Agent buffers and optimizes communication with the firewall

# Production History
This solution worked very well in an environment that was running Microsoft NPS with a Palo Alto firewall. Relying on the User-ID Agent on the firewall caused issues with the management plane, and 'known user' of the traffic would be occasionally blank, as the firewall was overwhelmed. Having the ability to create firewall rules based on User-ID was a game-changer.

# Final Notes
If you know a reseller who could sell me a license for a VM-500 or a VM-100, you would receive lots of love
