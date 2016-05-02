
# App Local

App Local provide a repeatable local development environment that matches the App Server infrastructure and associated databases and services.

## Contributors

* [Daniel Tedman](http://danieltedman.com)

See [GitHub Issues](https://github.com/dbtedman/app-local/issues) for the project's backlog.

## Dependencies

* [Vagrant (v1.8.1)](https://www.vagrantup.com)
* [Vagrant Librarian Puppet (v0.9.2)](https://github.com/mhahn/vagrant-librarian-puppet)
* [Vagrant Puppet Install (v4.1.0)](https://github.com/petems/vagrant-puppet-install)
* [Puppet Lint (v1.1.0)](http://puppet-lint.com/)
* [EditorConfig](http://editorconfig.org/)
* Internet Access

## Getting Started

1\. Ensure all **Dependencies** have been met.

2\. Define a `developer.yaml` configuration file:

```yaml
# Defines which directories will be mapped into apache root `/app` directory.
projects:
  # This would exist as /app/example in the VM.
  example: '../example-files'
```

3\. Define a `yaml/developer.yaml` configuration file:

```yaml
mysql:
    root_password: 'password'
```

4\. Start and provision VM:

```bash
vagrant up --provision
```

5\. View an index of deployed applications:

[https://localhost:8443](https://localhost:8443)

## Mapped Ports

| Port | VM Service |
|:---|:---|
| `8443` | HTTPS website. |
| `3306` | MySQL database. |

## Testing

This repositories tests are run per commit using [https://travis-ci.org](https://travis-ci.org).

### Static Analysis

```bash
puppet-lint --fix app_modules/
```
