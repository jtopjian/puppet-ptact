Preparation
===========

The `Vagrantfile` in this environment will create an LXC server that can be used to deploy the other examples.

The LXC server will be created in an OpenStack cloud. If you do not have access to an OpenStack cloud, modify the `Vagrantfile` to use a provider that you do have access to.

If you do have access to OpenStack:

  * Make sure you have the [vagrant-openstack-plugin](https://github.com/cloudbau/vagrant-openstack-plugin) installed.
  * Ensure the settings in the `Vagrantfile` are correct. For example, you will most likely need to change the network configuration.

Deploying
---------

Once you are sure your `Vagrantfile` is correct, just do:

```bash
$ vagrant up ptact
$ vagrant ssh ptact
```
