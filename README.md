# palo-userid-nps-nxlog
- Set the Palo Alto User-ID based on Microsoft NPS RADIUS authentication via NXLog CE as a tail/syslog collector, User-ID Agent on a Windows server
- Create firewall rules based on User-ID or group
- Palo Alto User-ID with Microsoft NPS RADIUS, XML logs, and NXLog CE to tail the log
- Optionally, run a PowerShell script on a regular basis on the User-ID Agent Windows server to add Active Directory computers to the exclude list

# Installation
## Microsoft NPS/RADIUS
- Configure Microsoft NPS with the default XML logging
## NXLog on NPS Host
- Install NXLog Community Edition
- Modify configuration file, copy to "C:\Program Files (x86)\nxlog\conf\nxlog.conf"
  - Replace NetBIOS domain name in configuration file with your NetBIOS domain
  - Regular expressions are used to parse and reconstruct the XML, so that it is under the required size and minimizes the data to the User-ID Agent
  - Extranneous entries are discarded rather than forwarded to the User-ID Agent, as per the regular expression(s) in the NXLog configuration file
## Windows Firewall on User-ID Agent Host
- Allow for TCP 514 for inbound syslog
- TCP is used, as it supports a greater length of syslog packet, and is reliable, as we need this to be a reliable process
## Palo Alto User-ID Agent
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

# Implementation History
This solution worked very well in an environment that was running Microsoft NPS with a Palo Alto firewall. Relying on the User-ID Agent on the firewall caused issues with the management plane, and 'known user' of the traffic would be occasionally blank, as the firewall was overwhelmed. Having the ability to create firewall rules based on User-ID was a game-changer.
