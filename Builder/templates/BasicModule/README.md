# <%= $PLASTER_PARAM_ModuleName %>

<%= $PLASTER_PARAM_ModuleDescription %>


## Environment Variables

Some parts of this module assume the use of environment variables for the storage of sensitive
"secrets" like account names or API tokens.

Specifically, be sure to either set the following environment variables or update the
configurations accordingly:


<%
  if ($PLASTER_PARAM_PackageRegistry -eq 'GitHub') {
    @'
### GitHub

- `GITHUB_USERNAME`: The GitHub account name to use for publishing.

- `GITHUB_PACKAGES_TOKEN`: An API token used to authenticate to GitHub packages. See the GitHub documentation on [Automatic token authentication](https://docs.github.com/en/actions/security-guides/automatic-token-authentication) for how to obtain a token.

'@
  }
%>
<%
  if ($PLASTER_PARAM_Options -contains 'Build') {
    @'
### Builder

- `BUILDER_STAGING_REPOSITORY_PATH`: Filesystem path to use as the source for the local staging PSRepository.

- `BUILDER_ORG_REGISTRY_SOURCE_URI`: URI of service index on internal NuGet server.

- `BUILDER_ORG_REGISTRY_PUBLISH_URI`: URI of publish endpoint on internal NuGet server.

- `BUILDER_ORG_REGISTRY_SEARCH_URI`: URI of search endpoint on internal NuGet server. Used for querying packages in debug tasks.

- `BUILDER_ORG_REGISTRY_API_KEY`: API token used for publishing packages to internal NuGet server.
'@
  }
%>
