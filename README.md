# [App Local](https://github.com/dbtedman/app-local)

[![GitHub Actions](https://github.com/dbtedman/app-local/workflows/Test/badge.svg)](https://github.com/dbtedman/app-local/actions?workflow=Test)

Provides a repeatable local development environment that matches an app server infrastructure, associated databases, and services.

## Where do I start?

### 0\. Ensure your machine has virtualization enabled. (Windows Only)

See the article ["How to find out if Intel VT-x or AMD-V Virtualization Technology is supported in Windows 10, Windows 8, Windows Vista or Windows 7 machine"](https://www.shaileshjha.com/how-to-find-out-if-intel-vt-x-or-amd-v-virtualization-technology-is-supported-in-windows-10-windows-8-windows-vista-or-windows-7-machine/) for instructions.

### 1\. Install [Virtual Box](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com).

### 2\. Install [Vagrant Puppet Install](https://github.com/petems/vagrant-puppet-install) vagrant plugins.

### 3\. Checkout [this repository](https://github.com/dbtedman/app-local) to your machine.

```bash
# The directory where your code lives.
cd /Users/danieltedman/Workspace

# Clone the repository.
git clone https://github.com/dbtedman/app-local.git
```

> The path to this repository e.g. `/Users/danieltedman/Workspace/app-local` will hereafter be refereed to as `$REPO`.

### 4\. Install ruby and [bundler](http://bundler.io/).

> If you are on Windows and see errors like `SSL_connect returned=1 errno=0 state=SSLv3 read server certificate B: certificate verify failed`, see [SSL Certificate Updates](http://guides.rubygems.org/ssl-certificate-update/) for instructions on how to fix this error. Or try [https://stackoverflow.com/questions/5720484/how-to-solve-certificate-verify-failed-on-windows](https://stackoverflow.com/questions/5720484/how-to-solve-certificate-verify-failed-on-windows)?

After installing ruby, you will need to make it accessible from within PowerShell. To do this, you must first change your [ExecutionPolicy](https://technet.microsoft.com/en-us/library/ee176961.aspx) to allow custom scripts. Run the following from within a PowerShell Run as Administrator session.

```PowerShell
Set-ExecutionPolicy Unrestricted
```

Create a `C:\Users\YOUR_ACCOUNT\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1` file with the following contents, replacing `Ruby23-x64` with the version you installed.

```PowerShell
$env:Path="$env:Path;C:\Ruby23-x64\bin"
```

Close all PowerShell windows and reopen one and run the following command to check everything was installed correctly.

```PowerShell
ruby --version
```

### 5\. Install ruby dependencies.

```bash
cd $REPO && bundle
```

### 6\. Install puppet module dependencies.

```bash
cd $REPO && bundle exec r10k puppetfile install --verbose
```

### 7\. Define a `$REPO/hiera/developer.yaml` configuration file to customise Puppet and Vagrant configuration.

```yaml
#
# Customize the PHP version. (Experimental)
#
php: "56"

#
# Enable OracleXE install and setup. (Experimental)
#
enable_oracle_xe: false

#
# OracleDB root password.
#
xe_root_password: ""

#
# File name for rpm zip downloaded from Oracle website.
#
xe_zip: "oracle-xe-??????.x86_64.rpm.zip"

#
# Enable or disable server spec acceptance tests.
#
enable_server_spec: false

#
# Configure memory allocation for VM.
#
virtualbox_memory: 4096

#
# SSO Demo Data. Update these to emulate a different user or a user with different access.
#
sso_dummy_staff_number: "s123456"
sso_dummy_given_name: "Jane"
sso_dummy_family_name: "Doe"
sso_dummy_email: "jane.doe@example.com"
sso_dummy_group_memberships:
    - "cn=General Staff (All),ou=Groups,o=Griffith University"
    - "cn=Staff (NA),ou=Groups,o=Griffith University"
sso_dummy_affiliations:
    - "EMPLOYEE"
    - "GENERAL"

#
# Used to customise which ports are mapped to on a developers workstation.
#
listen_ports:
    https: 8443
    mysql: 8306
    xe: 8521 # OracleXE database.

#
# Set to true if you get ssh auth errors when provisioning vm. This will stop vagrant from trying to
# replace the ssh keys that came with the base VM box.
#
disable_ssh_key_insert: false

#
# RPM files downloaded in dependencies instructions, add just the file names here not their full path.
#
oracle_instantclient_basic: "oracle-instantclient12.1-basic-??????.x86_64.rpm"
oracle_instantclient_development: "oracle-instantclient12.1-devel-??????.x86_64.rpm"
oracle_instantclient_sqlplus: "oracle-instantclient12.1-sqlplus-??????.x86_64.rpm"

#
# MySQL database configuration.
#
# The 'testdb' key is the name of the database, change this to change the database name.
# The 'testuser' key is the username being created, change this to change the username being created.
#
mysql:
    root_password: "password"

    databases:
        testdb:
            users:
                testuser:
                    password: "password"
                    grants:
                        - "ALL"

#
# Defines which repositories will be mapped into the VM and how.
#
# The key 'example' will be used in the url of the website, e.g. https://localhost:8443/example/.
# Change this to the name you want in the URL. The source is the location of the code on your
# development machine. Use '/' or '\' based on OS. The public is the path relative to the root of
# code as it will appear in the vm. It uses '/' here even if source is on Windows.
#
projects:
    example:
        source: "/Users/jane/Workspace/example"
        public: "/public"
```

### 8\. Download [Oracle InstantClient (.rpm) Files](http://www.oracle.com/technetwork/topics/linuxx86-64soft-092277.html) **basic**, **devel** and **sqlplus** into the `$REPO/app_modules/app_local/files` directory. The names of these files will need to be added to the `$REPO/heria/developer.yaml` config file for `oracle_instantclient_basic`, `oracle_instantclient_development` and `oracle_instantclient_sqlplus` properties.

```yaml
# Example based on instant client version at time of writing these instructions, the current version may be different.
oracle_instantclient_basic: "oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm"
oracle_instantclient_development: "oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm"
oracle_instantclient_sqlplus: "oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm"
```

### 9\. Download [Oracle Database Express Edition 11g Release 2 for Linux x64](http://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) into the `$REPO/app_modules/app_local/files` directory. The name will need to be added to the `$REPO/heria/developer.yaml` config file for `xe_zip` property.

> Only required if you enable (experimental) Oracle XE DB setup in your `hiera/developer.yaml` file.

```yaml
# Example based on instant client version at time of writing these instructions, the current version may be different.
xe_zip: "oracle-xe-11.2.0-1.0.x86_64.rpm.zip"
```

### 10\. Update the `$REPO/heria/developer.yaml` file, `projects` section to map projects in your workspace into the VM.

> When mapping new projects into the vm or updating the configuration of existing ones, you will need to run the `vagrant reload --provision` command to apply these changes. This is not required however when you are first setting up app-local vm.

```yaml
projects:
    apples:
        source: 'D:\Workspace\apples-git'
        public: "/public/"
```

> In the above example, the key `apples` will be used to create the URL `https://localhost:8443/apples/` which will read files from the `/public/` subdirectory of the `D:\Workspace\apples-git` source directory on your workstation. For example, `https://localhost:8443/apples/about.txt` will return the contents of the `D:\Workspace\apples-git\public\about.txt` file. Slashes `\` or `/` in the source property are based on your workstation operating system, however the public path will always use `/` slashes.

### 11\. Start and provision the virtual machine.

```bash
cd $REPO && vagrant up --provision
```

> See [Vagrant CLI](https://www.vagrantup.com/docs/cli) for documentation on how to interact with the vm.

### 12\. View an index of deployed applications, [https://localhost:8443](https://localhost:8443).

### 13\. Connect to installed databases. This will be based on the `listen_ports` properties defined in the `$REPO/heria/developer.yaml` config file.

```yaml
# Example configuration, your port mappings may be configured differently.
listen_ports:
    https: 8443
    mysql: 8306
    xe: 8521 # OracleXE database.
```

## Want to lean more?

-   See our [Contributing Guide](CONTRIBUTING.md) for details on how this repository is developed.
-   See our [Changelog](CHANGELOG.md) for details on which features, improvements, and bug fixes have been implemented
-   See our [License](LICENSE.md) for details on how you can use the code in this repository.
-   See our [Security Guide](SECURITY.md) for details on how security is considered.
