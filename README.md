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
