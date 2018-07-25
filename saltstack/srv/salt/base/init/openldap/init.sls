openldap-install:
  pkg.installed:
    - pkgs: 
      - openldap
      - openldap-clients
      - openldap-devel
      - openldap-servers
      - openldap-servers-sql
      - nscd 
      - nss-pam-ldapd 
      - pcre 
      - pcre-static
      - pcre-devel

openldap-config:
  
