# Build and Release GitHub Action

This repository contains a GitHub Actions workflow that automates building projects from specified repositories and creating draft releases with the build artifacts.

## Features

- ✅ Checkout code from any repository and branch
- ✅ Run custom Gradle build commands
- ✅ Upload specified artifacts to GitHub draft releases
- ✅ Automatic release tagging with timestamps
- ✅ Java/Gradle environment setup with caching

## Workflow Inputs

The workflow accepts the following inputs:

| Input | Description | Required | Default | Example |
|-------|-------------|----------|---------|---------|
| `repository` | Repository to build (owner/repo format) | Yes | - | `opensearch-project/OpenSearch` |
| `branch` | Branch to checkout | Yes | `main` | `main` or `2.x` |
| `build_command` | Gradle build command to execute | Yes | `./gradlew build` | `./gradlew assemble` |
| `artifact_path` | Path to the file to upload | Yes | - | `build/distributions/opensearch-min-3.0.0-SNAPSHOT-linux-x64.tar.gz` |

## How to Use

1. **Navigate to Actions tab** in your GitHub repository
2. **Select "Build and Release"** workflow from the left sidebar
3. **Click "Run workflow"** button
4. **Fill in the required inputs**:
   - Repository: Enter the repository in `owner/name` format
   - Branch: Enter the branch name you want to build
   - Build command: Enter the Gradle command to run
   - Artifact path: Enter the path to the file you want to upload
5. **Click "Run workflow"** to start

## Example Usage

### Building OpenSearch

```yaml
repository: opensearch-project/OpenSearch
branch: main
build_command: ./gradlew :distribution:archives:linux-tar:assemble
artifact_path: distribution/archives/linux-tar/build/distributions/opensearch-3.0.0-SNAPSHOT-linux-x64.tar.gz
```

### Building a Custom Plugin

```yaml
repository: myorg/opensearch-plugin
branch: develop
build_command: ./gradlew build
artifact_path: build/distributions/my-plugin-1.0.0.zip
```

## Workflow Details

The workflow performs the following steps:

1. **Checkout**: Clones the specified repository and branch
2. **Setup Java**: Installs JDK 21 with Gradle caching enabled
3. **Build**: Executes the provided Gradle build command
4. **Verify**: Checks that the artifact exists at the specified path
5. **Create Release**: Creates a draft release with a timestamp tag
6. **Upload**: Uploads the artifact to the draft release

## Release Naming

Releases are automatically tagged with timestamps in the format:
- Tag: `release-YYYYMMDD-HHMMSS`
- Example: `release-20260202-143530`

The release name includes the branch and tag for easy identification.

## Requirements

- The target repository must contain a Gradle project with `gradlew` wrapper
- The specified artifact path must exist after the build completes
- GitHub token with appropriate permissions (automatically provided)

## Notes

- All releases are created as **drafts** - you need to manually publish them
- The workflow uses JDK 21 by default
- Gradle dependencies are cached to speed up subsequent builds
- The artifact content type is set to `application/zip` (works for most archive formats)

## Troubleshooting

### "Artifact not found" error
- Verify the artifact path is correct relative to the repository root
- Check that the build command successfully creates the artifact
- Ensure the path includes the correct file extension

### Permission errors
- Ensure the repository has Actions enabled
- Check that the GitHub token has necessary permissions

### Build failures
- Verify the build command is correct for the target repository
- Check the Java version compatibility
- Review build logs in the Actions tab

## License

This workflow is provided as-is for use in your projects.
