git module
```
---
- name: Clone Certbot into configured directory.
  git:
    repo: "{{ certbot_repo }}"
    dest: "{{ certbot_dir }}"
    version: "{{ certbot_version }}"
    update: "{{ certbot_keep_updated }}"
    force: yes
```
