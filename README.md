# Releasaurus GitHub Action 🦕

A custom GitHub Action that runs [releasaurus] to automate the release process
for GitHub repositories. This action handles creating releases and release pull
requests automatically.

## What it does

This action uses the releasaurus tool to:

2. **Create release pull requests** - Opens and updates release PR for incoming
   changes where you can review changelog updates and version bumps prior to
   release. Changelog and next version are automatically determined based on
   your repository's commit history and conventional commits.
1. **Create releases** - On merge of release PR, releasaurus adds the
   appropriate tags to the commit and creates releases with auto-generated notes

## Usage

### Basic Usage

```yaml
- name: Run Releasaurus
  uses: robgonnella/releasaurus-action@v1
```

### With Custom Inputs

```yaml
- name: Run Releasaurus
  uses: robgonnella/releasaurus-action@v1
  with:
    repo: https://github.com/owner/repo-name
    token: ${{ secrets.GITHUB_TOKEN }}
    clone_depth: "500"
    debug: "true"
    git_user_name: "My Release Bot"
    git_user_email: "releases@mycompany.com"
```

### With Full Repository History

For repositories with extensive commit history where you want to include the
full commit history in changelog generation, you'll want to clone the entire
history to ensure releasaurus has access to all commits for accurate release
note generation:

```yaml
- name: Run Releasaurus with Full History
  uses: robgonnella/releasaurus-action@v1
  with:
    clone_depth: "0" # Clone all history
    debug: "true"
```

## Inputs

| Input            | Description                                  | Required | Default                                             |
| ---------------- | -------------------------------------------- | -------- | --------------------------------------------------- |
| `repo`           | The GitHub repository URL to affect          | No       | `${{ github.server_url }}/${{ github.repository }}` |
| `token`          | GitHub token for authentication. Must have   | No       | `${{ github.token }}`                               |
|                  | permissions to create PRs, tags, labels, and |          |                                                     |
|                  | releases                                     |          |                                                     |
| `clone_depth`    | Sets the clone depth for the target          | No       | `"250"`                                             |
|                  | repository. Set to 0 to clone all history    |          |                                                     |
| `debug`          | Enable debug logging                         | No       | `"false"`                                           |
| `git_user_name`  | The git user name to use when committing     | No       | `"ReleasaurusCI"`                                   |
|                  | and creating tags                            |          |                                                     |
| `git_user_email` | The git user email to use when committing    | No       | `"releasaurus-ci@noreply.com"`                      |
|                  | and creating tags                            |          |                                                     |

## Outputs

This action does not produce any outputs.

## Permissions

The GitHub token used by this action requires the following permissions:

- **Contents**: `write` - To create tags and releases
- **Pull requests**: `write` - To create release pull requests
- **Issues**: `write` - To create and manage labels

### Example with explicit permissions

```yaml
name: Release
on:
  push:
    branches: [main]

jobs:
  release:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
    steps:
      - name: Checkout
        uses: actions/checkout@v5
      - name: Run Releasaurus
        uses: robgonnella/releasaurus-action@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

## Complete Workflow Example

```yaml
name: Automated Releases

on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  release:
    name: Create Release
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write
      issues: write
    steps:
      - name: Checkout repository
        uses: actions/checkout@v5
      - name: Run Releasaurus
        uses: robgonnella/releasaurus-action@v1
        with:
          debug: "false"
```

## How Releasaurus Works

Releasaurus scans your repository's commit history to:

2. **Determine version bumps** - Calculates the next version based on commit types (feat, fix, BREAKING CHANGE, etc.)
3. **Generate release notes** - Creates comprehensive release notes from commit history
4. **Create releases** - Publishes GitHub releases with generated notes
5. **Manage release PRs** - Opens pull requests for upcoming releases

Although it's not required, Releasaurus works best if your repository follows
[Conventional Commits] standard and keeps a linear history in the default
branch.

## Troubleshooting

### Common Issues

**Permission denied errors**: Ensure your GitHub token has the necessary
permissions listed above.

**No release-pr or release created**:

- Check that there aren't multiple merged release PRs with a
  "releasaurus:pending" tag. If there are, remove the pending label from the
  older PRs so that only the latest merged release PR has the pending label,
  then re-run releasaurus
- Check that the repository has releasable commits

**Insufficient commit history for analysis**: If releasaurus can't find enough
commit history to determine releases, try increasing the `clone_depth` or set
it to `"0"` to clone the full repository history:

```yaml
- name: Run Releasaurus with Full History
  uses: robgonnella/releasaurus-action@v1
  with:
    clone_depth: "0"
```

**Debug logging**: Set the `debug` input to `"true"` to get more detailed logs:

```yaml
- name: Run Releasaurus (Debug)
  uses: robgonnella/releasaurus-action@v1
  with:
    debug: "true"
```

## Requirements

- GitHub token with appropriate permissions
- Repository should have at least one commit to analyze

## Docker Image

This action uses the Docker image [rgonnella/releasaurus]. The
releasaurus tool is maintained separately and you can find more information
about it in its [official repository][releasaurus].

## Contributing

If you find issues with this GitHub Action or want to contribute improvements,
please open an issue or submit a pull request.

## License

This project is licensed under the same terms as the releasaurus tool. Please
refer to the original project for license details.

[releasaurus]: https://github.com/robgonnella/releasaurus
[Conventional Commits]: https://www.conventionalcommits.org/en/v1.0.0/
[rgonnella/releasaurus]: https://hub.docker.com/repository/docker/rgonnella/releasaurus/general
