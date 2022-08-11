# palo-userid-nps-nxlog
Palo Alto User-ID with Microsoft NPS RADIUS, XML logs, and nxlog CE to tail the log.

# Installation
## NPS
- Copnfigure Microsoft NPS with the default XML logging
## NXLog
- Install NXLog Community Edition
- Modify configuration file, copy to "C:\Program Files (x86)\nxlog\nxlog.conf"
## Windows Firewall on User-ID Agent host
- Allow for UDP 514 for inbound syslog
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
  
