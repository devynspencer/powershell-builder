# <%= $PLASTER_PARAM_ModuleName %>

<%= $PLASTER_PARAM_ModuleDescription %>

<%
  if ($PLASTER_PARAM_PackageRegistry -eq 'GitHub') {
    @'
# Environment Variables

Some parts of this module assume the use of environment variables for the storage of sensitive
"secrets" like account names or API tokens.

Specifically, be sure to either set the following environment variables or update the
configurations accordingly:

- `GITHUB_USERNAME`: The GitHub account name to use for publishing.

- `GITHUB_PACKAGES_TOKEN`: An API token used to authenticate to GitHub packages. See the GitHub documentation on [Automatic token authentication](https://docs.github.com/en/actions/security-guides/automatic-token-authentication) for how to obtain a token.
'@
  }
%>
