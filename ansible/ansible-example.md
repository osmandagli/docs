# Ansible example
Recursive ansible automation example

~~~
- name: Check Environment
  hosts: all
  become: true
  vars_prompt:
    - name: docker_image
      prompt: Is it image or file ?
      private: false
  tasks:
    - name: Set environment fact
      set_fact:
        env: "{{ docker_image }}"
    
- import_playbook: /home/ssh-client/ansible/docker_pull_push.yml
  when: env == "image"

- import_playbook: /home/ssh-client/ansible/docker_with_file.yml
  when: env == "file"      
       
          
          #- when: env == image
          #  ansible.builtin.import_playbook: docker_login.yml
          #- when: env == file
          #  ansible.builtin.import_playbook: input_file.yml
~~~

~~~
- hosts: all
  vars_prompt:
    - name: path
      prompt: What is the path to docker images?
      default: /home/ssh-client/ansible/docker-images
      private: false
  tasks:
    - ansible.builtin.shell: ansible-playbook /home/ssh-client/ansible/docker_pull_push.yml --extra-vars "docker_image={{item}} ansible_sudo_pass=2314"
      with_lines: cat {{ path }}
~~~

~~~
- name: one image
  hosts: all
  vars_prompt:
    - name: docker_image
      prompt: What is the image ?
      private: false
  vars:
    docker_image: null
  tasks:
    - name: login docker repo
      ansible.builtin.shell:
        cmd: nerdctl login localhost:31564 --username admin --password admin123
    - name: pull the image
      ansible.builtin.shell:
        cmd:  echo 2314 | sudo -S -k nerdctl pull {{ docker_image }}
    - name: tag the image
      ansible.builtin.shell:
        cmd: echo 2314 | sudo -S -k nerdctl tag {{ docker_image }} localhost:31564/{{ docker_image }}
    - name: push the image
      ansible.builtin.shell:
        cmd: echo 2314 | sudo -S -k nerdctl push localhost:31564/{{ docker_image}}
~~~

~~~
- name: helm push to nexus repo
  hosts: all
  vars_prompt:
    - name: chart_name
      prompt: What is the name of helm chart (must be located in /home/ssh-client/helm-packages/) ?
      private: false
    - name: nexus_username
      prompt: What is the nexus username ?
      private: false
    - name: nexus_password
      prompt: What is the nexus password ?
      private: true
  vars:
    helm_chart_url: "http://localhost:30998/repository/helm-bbk/"
  tasks:
    - name: Add helm repo
      kubernetes.core.helm_repository:
        name: bbk_repo
        repo_url: "{{ helm_chart_url }}"
        repo_username: "{{ nexus_username }}"
        repo_password: "{{ nexus_password }}"
    - name: helm package
      ansible.builtin.shell:
        chdir: /home/ssh-client/helm-packages
        cmd: echo "2314" | sudo -S -k helm package {{ chart_name }}
    - name: give permission to chart package
      ansible.builtin.shell:
        chdir: /home/ssh-client/helm-packages
        cmd: echo "2314" | sudo -S -k chmod 777 {{ chart_name }}* 
    - name: helm push
      ansible.builtin.shell:
        chdir: /home/ssh-client/helm-packages
        cmd: echo "2314" | sudo -S -k curl -u {{ nexus_username }}:{{ nexus_password }} {{ helm_chart_url}} --upload-file {{ chart_name }}-*
~~~



