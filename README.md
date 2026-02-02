# Build and Release GitHub Action

This repository contains a GitHub Actions workflow that automates building projects from specified repositories and creating draft releases with the build artifacts.

## Features

- ✅ Preset configurations for common OpenSearch builds
- ✅ Checkout code from any repository and branch
- ✅ Run custom Gradle build commands
- ✅ Upload specified artifacts to GitHub draft releases
- ✅ Automatic release tagging with timestamps
- ✅ Java/Gradle environment setup with caching

## Available Presets

Preset configurations are stored in the `presets/` folder as YAML files. Each preset defines:
- Repository to build from
- Gradle build command
- Artifact path pattern (with wildcard support)

**Current presets:**

| Preset | Repository | Build Command | Artifact Pattern |
|--------|-----------|---------------|------------------|
| `opensearch-arrow-flight-rpc` | opensearch-project/OpenSearch | `./gradlew :plugins:arrow-flight-rpc:assemble` | `plugins/arrow-flight-rpc/build/distributions/arrow-flight-rpc-*.zip` |
| `opensearch-core` | opensearch-project/OpenSearch | `./gradlew :libs:opensearch-core:assemble` | `libs/opensearch-core/build/distributions/opensearch-core-*.jar` |
| `opensearch-linux-tar` | opensearch-project/OpenSearch | `./gradlew :distribution:archives:linux-tar:assemble` | `distribution/archives/linux-tar/build/distributions/opensearch-*.tar.gz` |
| `opensearch-plugin-template` | opensearch-project/opensearch-plugin-template | `./gradlew build` | `build/distributions/*.zip` |
| `custom` | User-specified | User-specified | User-specified |

## Workflow Inputs

The workflow accepts the following inputs:

| Input | Description | Required | Default | Example |
|-------|-------------|----------|---------|---------|
| `preset` | Preset configuration to use | Yes | `custom` | `opensearch-arrow-flight-rpc` |
| `repository` | Repository to build (owner/repo format) - only for custom preset | No | - | `opensearch-project/OpenSearch` |
| `branch` | Branch to checkout | Yes | `main` | `main` or `2.x` |
| `build_command` | Gradle build command - only for custom preset | No | - | `./gradlew assemble` |
| `artifact_path` | Path/pattern to the file to upload - only for custom preset | No | - | `build/distributions/*.zip` |

## How to Use

### Using a Preset

1. **Navigate to Actions tab** in your GitHub repository
2. **Select "Build and Release"** workflow from the left sidebar
3. **Click "Run workflow"** button
4. **Select a preset** from the dropdown (e.g., `opensearch-arrow-flight-rpc`)
5. **Enter the branch** you want to build (default: `main`)
6. **Click "Run workflow"** to start

### Using Custom Configuration

1. **Navigate to Actions tab** in your GitHub repository
2. **Select "Build and Release"** workflow from the left sidebar
3. **Click "Run workflow"** button
4. **Select "custom"** from the preset dropdown
5. **Fill in the required inputs**:
   - Repository: Enter the repository in `owner/name` format
   - Branch: Enter the branch name you want to build
   - Build command: Enter the Gradle command to run
   - Artifact path: Enter the path/pattern to the file you want to upload
6. **Click "Run workflow"** to start

## Example Usage

### Using Preset: Arrow Flight RPC Plugin

```yaml
preset: opensearch-arrow-flight-rpc
branch: main
```

This will automatically build the Arrow Flight RPC plugin from the OpenSearch repository.

### Using Preset: OpenSearch Linux Distribution

```yaml
preset: opensearch-linux-tar
branch: 2.x
```

This will build the OpenSearch Linux tar distribution from the 2.x branch.

### Custom Build Example

```yaml
preset: custom
repository: myorg/opensearch-plugin
branch: develop
build_command: ./gradlew build
artifact_path: build/distributions/my-plugin-*.zip
```

## Workflow Details

The workflow performs the following steps:

1. **Apply Preset**: Determines the repository, build command, and artifact pattern based on the selected preset
2. **Checkout**: Clones the specified repository and branch
3. **Setup Java**: Installs JDK 21 with Gradle caching enabled
4. **Build**: Executes the provided Gradle build command
5. **Find Artifact**: Locates the artifact file matching the pattern (supports wildcards)
6. **Create Release**: Creates a draft release with a timestamp tag
7. **Upload**: Uploads the artifact to the draft release

## Release Naming

Releases are automatically tagged with timestamps in the format:
- Tag: `release-YYYYMMDD-HHMMSS`
- Example: `release-20260202-143530`

The release name includes the branch and tag for easy identification.

## Adding New Presets

To add a new preset configuration:

1. Create a new YAML file in the `presets/` folder (e.g., `presets/my-new-preset.yml`)
2. Add the following fields:

```yaml
name: My New Preset Name
repository: owner/repository-name
build_command: ./gradlew <your-gradle-command>
artifact_pattern: path/to/artifact-*.zip
```

3. Update the workflow file `.github/workflows/build-and-release.yml` to add your preset to the options list:

```yaml
options:
  - custom
  - opensearch-arrow-flight-rpc
  - opensearch-core
  - opensearch-linux-tar
  - opensearch-plugin-template
  - my-new-preset  # Add your preset here
```

4. Commit and push the changes

**Example preset file (`presets/my-plugin.yml`):**

```yaml
name: My Custom Plugin
repository: myorg/my-opensearch-plugin
build_command: ./gradlew :plugin:assemble
artifact_pattern: plugin/build/distributions/my-plugin-*.zip
```

## Requirements

- The target repository must contain a Gradle project with `gradlew` wrapper
- The specified artifact path must exist after the build completes
- GitHub Actions must have write permissions for contents (releases)
  - Go to **Settings** → **Actions** → **General** → **Workflow permissions**
  - Select "Read and write permissions"
  - Save the changes

## Notes

- All releases are created as **drafts** - you need to manually publish them
- The workflow uses JDK 21 by default
- Gradle dependencies are cached to speed up subsequent builds
- Artifact paths support wildcards (e.g., `build/distributions/*.zip`)
- When using presets, only the branch input needs to be specified
- The artifact content type is set to `application/zip` (works for most archive formats)

## Troubleshooting

### "Artifact not found" error
- Verify the artifact path/pattern is correct relative to the repository root
- Check that the build command successfully creates the artifact
- Ensure the path includes the correct file extension
- Wildcards are supported (e.g., `*.zip`) - the first matching file will be uploaded

### "Resource not accessible by integration" error
- This means GitHub Actions doesn't have permission to create releases
- Go to your repository **Settings** → **Actions** → **General**
- Under "Workflow permissions", select **"Read and write permissions"**
- Click **Save**
- Re-run the workflow

### Permission errors
- Ensure the repository has Actions enabled
- Check that workflow permissions are set to "Read and write"

### Build failures
- Verify the build command is correct for the target repository
- Check the Java version compatibility
- Review build logs in the Actions tab

## License

This workflow is provided as-is for use in your projects.
