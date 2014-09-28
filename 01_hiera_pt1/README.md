Multiple Hierarchies with Hiera
===============================

This environment highlights the difficulties in understanding multiple hierarchies with Hiera.

Hiera Configuration
-------------------
`puppet/site/ext/hiera.yaml` is is the Hiera configuration file that is copied to `/etc/puppet/hiera.yaml`. It defines 3 hierarchies:

  * `nodes/%{::fqdn}`: settings specific to individual nodes
  * `locations/%{::location}`: settings specific to certain locations
  * `common`: settings applied to all nodes

Node Configuration
------------------
This environment defines 3 nodes:

  * puppet.example.com located in Honolulu
  * node-1.example.com located in Honolulu
  * node-2.example.com located in Maui

SSH Keys via Hiera
------------------
The main purpose of this scenario is to define several SSH keys across the three nodes. `puppet/site/data` contains the actual Hiera data.

The nodes will receive the following SSH keys:

  * puppet.example.com: `user1`, `user2`, `user3`
  * node-1.example.com: `user1`, `user2`
  * node-2.example.com: `user1`, `user4`

The SSH keys can be deployed in two different ways:

  * [Automatic Parameter Lookup](https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup)
  * [hiera_array()](https://docs.puppetlabs.com/references/latest/function.html#hieraarray)

By default, Automatic Parameter Lookup is used. To switch to `hiera_array()`, comment out the `site::profiles::ssh::keys` section in all YAML files.

Advantages and Disadvantages
----------------------------
### hiera_array()
`hiera_array()` is able to collect Hiera data across all hierarchies that a node is part of and combine them into a single variable. The advantages to this are that settings are not duplicated and complex structures can be easily created.

The disadvantage is the unintuitiveness that is created by trying to figure out all settings a particular node gets. Puppet provides no easy way of seeing all Hiera data that a particular node has access to. The `hiera` command-line tool can display this data, but you must specify all attributes about the node. It would be a lot easier if only the node name was specified and Puppet figured the rest out.

Another disadvantages is that the Hiera setting can not be the same as the class name or it will conflict with Automatic Parameter Lookup. This is why the setting is called `ssh::keys`. There is no easy way to map the setting name to where in the Puppet environment it is actually applied. It could be used in several places which makes tracking of settings even more difficult.

In the end, you will probably end up doing a `grep -R ssh::keys data/*` to see where all places `ssh::keys` is defined and then figure out which ones are applicable to the particular node.

### Automatic Parameter Lookup
The advantages of APL is that the full class name must be used when defining a Hiera setting. When an admin browses the Hiera YAML files, they are easily able to see where settings are applied.

The disadvantage is that `hiera_array()` and `hiera_hash()` are not able to be used. This means that if multiple types of nodes are to receive the same data, then data will be duplicated across Hiera YAML files. If the setting were to ever change, you must ensure that it was changed in all locations.

Conclusion
----------
It seems as though both APL and `hiera_array()` / `hiera_hash()` provide diametrical benefits. This is very unfortunate as either choice brings its own set of disadvantages.
