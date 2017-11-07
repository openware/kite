#### [Back](../README.md)

## OAuth (UAA)

### Configuration

If you want to add initial groups and users, change oauth look,
configure mail, etc. - you should edit `config/oauth.yml`.

Here are links to uaa config documentation:

* __users:__ [uaa.scim.users](https://bosh.io/jobs/uaa?source=github.com/cloudfoundry/uaa-release&version=52#p=uaa.scim.users)
* __groups:__ [uaa.scim.groups](https://bosh.io/jobs/uaa?source=github.com/cloudfoundry/uaa-release&version=52#p=uaa.scim.groups)
* __oauth clients:__ [uaa.clients](https://bosh.io/jobs/uaa?source=github.com/cloudfoundry/uaa-release&version=52#p=uaa.clients)
* __theming:__ [login.branding](https://bosh.io/jobs/uaa?source=github.com/cloudfoundry/uaa-release&version=52#p=login.branding)
* __email notifications:__ [login.smtp](https://bosh.io/jobs/uaa?source=github.com/cloudfoundry/uaa-release&version=52#p=login.smtp)

### Deployment

After editing config, run `./bin/oauth-deploy.sh`

### Usage

To check if OAuth works, visit [<%= @values['oauth']['hostname'] %>](<%= @values['oauth']['url'] %>).
