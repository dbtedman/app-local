# frozen_string_literal: true

#-------------------------------------------------------------------------------
#
# Vagrant Configuration, https://www.vagrantup.com.
#
#-------------------------------------------------------------------------------

require 'yaml'

Vagrant.configure(2) do |config|
  developer = {}

  #
  # Load developer config to customise vm and define mapped folders.
  #
  developer = YAML.safe_load(File.open('hiera/developer.yaml')) if File.exist? 'hiera/developer.yaml'

  #
  # Handle errors with ssh key insertion.
  #
  config.ssh.insert_key = false if developer.key?('disable_ssh_key_insert') && (developer['disable_ssh_key_insert'] == true)

  #
  # Get CentOS Box, https://atlas.hashicorp.com/puppetlabs/boxes/centos-7.2-64-puppet/versions/1.0.1.
  #
  config.vm.box = 'puppetlabs/centos-7.2-64-puppet'
  config.vm.box_version = '1.0.1'

  #
  # Vagrant Puppet Install, https://github.com/petems/vagrant-puppet-install.
  #
  config.puppet_install.puppet_version = :latest

  #
  # Vagrant VM Config, https://www.vagrantup.com/docs/multi-machine/.
  #
  config.vm.define 'localhost' do |app|
    app.vm.hostname = 'localhost'

    listen_https = 8443
    listen_mysql = 8306
    listen_xe = 8521

    if developer.key? 'listen_ports'
      listen_ports = developer['listen_ports']
      listen_https = listen_ports['https'] if listen_ports.key? 'https'
      listen_mysql = listen_ports['mysql'] if listen_ports.key? 'mysql'
      listen_xe = developer['listen_ports']['xe'] if listen_ports.key? 'xe'
    end

    app.vm.network 'forwarded_port', guest: 443, host: listen_https, host_ip: '127.0.0.1'
    app.vm.network 'forwarded_port', guest: 3306, host: listen_mysql, host_ip: '127.0.0.1'
    app.vm.network 'forwarded_port', guest: 1521, host: listen_xe, host_ip: '127.0.0.1'

    if developer.key? 'projects'
      developer['projects'].each_pair do |to, from|
        from_path = File.expand_path(from['source'], File.dirname(__FILE__))
        to_path = "/app/source/#{to}"

        if developer.key?('enable_rsync') && (developer['enable_rsync'] == true)

          if Vagrant.has_plugin?('vagrant-gatling-rsync')
            config.gatling.latency = 1
            config.gatling.time_format = '%H:%M:%S'
            config.gatling.rsync_on_startup = false
          end

          app.vm.synced_folder from_path, to_path, type: 'rsync', rsync__verbose: true, rsync__exclude: %w[*.git/ *.idea/ *.svn/]

        else
          # Using standard VirtualBox folder sync.
          app.vm.synced_folder from_path, to_path
        end
      end
    end
  end

  #
  # Update hosts file to define "puppet" domain in hosts file as 127.0.0.1. This is important to
  # stop puppet from calling out to any puppet server that exists on the network.
  #
  config.vm.provision 'shell', inline: 'cp /vagrant/app_modules/app_local/files/hosts /etc/hosts && systemctl restart puppet'

  #
  # Running the Puppet Apply command to provision the machine.
  #
  config.vm.provision 'shell', name: 'puppet_apply' do |shell|
    modules = '/vagrant/modules'
    app_modules = '/vagrant/app_modules'
    manifest = "#{app_modules}/app_local/manifests/local.pp"
    hiera_config = '/vagrant/hiera/hiera.yaml'

    shell.inline = "puppet apply --hiera_config=#{hiera_config} --modulepath=#{modules}:#{app_modules} #{manifest}"
  end

  #
  # ServerSpec testing, only enabled for acceptance testing purposes.
  #
  if developer.key?('enable_server_spec') && (developer['enable_server_spec'] == true)
    config.vm.provision 'serverspec' do |spec|
      spec.pattern = './spec-acceptance/localhost/*'
    end
  end

  #
  # Configuration for VirtualBox.
  #
  config.vm.provider 'virtualbox' do |vb|
    # Used to ensure that VM can create symbolic links in shared folders, based on http://serverfault.com/questions/501599.
    vb.customize ['setextradata', :id, 'VBoxInternal2/SharedFoldersEnableSymlinksCreate//vagrant', '1']

    if developer.key? 'virtualbox_memory'
      vb.customize ['modifyvm', :id, '--memory', developer['virtualbox_memory']]
    else
      vb.customize ['modifyvm', :id, '--memory', 2048]
    end

    vb.customize ['modifyvm', :id, '--cpus', '2']
  end
end
