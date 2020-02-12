# [App Local](./README.md) / Contributing

-   [Auto Formatting](#auto-formatting)
-   [Acceptance Tests](#acceptance-tests)

## Auto Formatting

```bash
./bin/format
```

## Acceptance Tests

Provided by [ServerSpec](http://serverspec.org), and is run by Vagrant when the `enable_server_spec` property is set to `true` in your `hiera/developer.yaml` configuration file. See `spec/localhost` for avialable specifications. You will need to install the [Vagrant ServerSpec](https://github.com/vvchik/vagrant-serverspec) plugin if you wish to run the acceptance test suite.

To execute just the acceptance tests, after running the standard setup procedure:

```bash
vagrant provision --provision-with serverspec
```
