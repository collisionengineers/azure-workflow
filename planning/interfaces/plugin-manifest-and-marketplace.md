# Plugin manifest and marketplace contract

## Scaffold command

Run from the repository root. Resolve the installed `plugin-creator` script from `CODEX_HOME`, or from Codex's documented per-user default when `CODEX_HOME` is unset. If the active skill reports a different filesystem locator, use that discovered locator for the current session without recording it in the repository.

```powershell
$azureWorkflowCodexRoot = if ([string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
  Join-Path ([Environment]::GetFolderPath('UserProfile')) '.codex'
} else {
  $env:CODEX_HOME
}
$pluginCreatorSkillRoot = Join-Path $azureWorkflowCodexRoot 'skills\.system\plugin-creator'
$createPlugin = Join-Path $pluginCreatorSkillRoot 'scripts\create_basic_plugin.py'

if (-not (Test-Path -LiteralPath $createPlugin -PathType Leaf)) {
  throw 'Select or install plugin-creator before scaffolding.'
}

python $createPlugin azure-workflow `
  --path .\plugins `
  --marketplace-path .\.agents\plugins\marketplace.json `
  --with-skills `
  --with-scripts `
  --with-mcp `
  --with-marketplace
```

Do not pass `--with-hooks`, `--with-assets`, `--with-apps`, `--marketplace-name`, or `--force`.

The skill folders are initialized separately with `skill-creator`; the plugin scaffold only creates the plugin-level directories and manifests.

## Exact plugin manifest

Path: `plugins/azure-workflow/.codex-plugin/plugin.json`

```json
{
  "name": "azure-workflow",
  "version": "0.1.0-alpha.1",
  "description": "Own Azure repository onboarding, planning, delivery, explanation, review, and controlled operations.",
  "author": {
    "name": "Collision Engineers",
    "url": "https://github.com/collisionengineers"
  },
  "homepage": "https://github.com/collisionengineers/azure-workflow",
  "repository": "https://github.com/collisionengineers/azure-workflow",
  "keywords": [
    "azure",
    "repository",
    "workflow",
    "documentation",
    "delivery",
    "explanation",
    "review"
  ],
  "skills": "./skills/",
  "mcpServers": "./.mcp.json",
  "interface": {
    "displayName": "Azure Workflow",
    "shortDescription": "Own and explain Azure repository work from plan to reviewed PR.",
    "longDescription": "Converts Azure repositories to a durable documentation and GitHub standard, explains repository behavior and feedback in plain English, creates decision-complete plans, delivers independently reviewed changes, and gates Azure mutations with explicit approval.",
    "developerName": "Collision Engineers",
    "category": "Productivity",
    "capabilities": [
      "Repository onboarding",
      "Feature planning",
      "Implementation",
      "Plain-language explanation",
      "Independent review",
      "Azure operations"
    ],
    "websiteURL": "https://github.com/collisionengineers/azure-workflow",
    "defaultPrompt": [
      "Onboard this Azure repository into the workflow standard.",
      "Plan this repository change and stop before implementation.",
      "Deliver this repository change through a green exact-head-reviewed pull request."
    ]
  }
}
```

Rules:

- The outer folder and manifest name must both remain `azure-workflow`.
- Use strict Semantic Versioning. The first package is the prerelease `0.1.0-alpha.1`. Development cachebusters are appended as build metadata with the plugin-creator update helper; do not increment the release version merely to reload Codex.
- Omit `license` while the repository is private and no licence has been selected.
- Omit `hooks`, `apps`, product gating, logos, icons, screenshots, privacy URL, and terms URL.
- `mcpServers` remains a path because `.mcp.json` exists.
- No manifest field may contain a TODO placeholder.
- Keep `interface.defaultPrompt` to the three lifecycle starters above. The six individual skills expose their own exact starter prompts through `agents/openai.yaml`.

## Exact marketplace manifest

Path: `.agents/plugins/marketplace.json`

```json
{
  "name": "personal",
  "interface": {
    "displayName": "Personal"
  },
  "plugins": [
    {
      "name": "azure-workflow",
      "source": {
        "source": "local",
        "path": "./plugins/azure-workflow"
      },
      "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL"
      },
      "category": "Productivity"
    }
  ]
}
```

Rules:

- Keep the scaffold's default marketplace name `personal`; no other personal marketplace currently exists.
- The repository is an explicit, non-default marketplace location, so it must be registered with `codex plugin marketplace add <repo-root>` before installation.
- Keep the source path relative to the marketplace root as `./plugins/azure-workflow`.
- Do not add `policy.products`.
- Do not hand-edit this file during later reinstall cycles. Use the cachebuster and Codex CLI update flow.

## Validation

The package is not ready until all of these pass:

```powershell
$validatePlugin = Join-Path $pluginCreatorSkillRoot 'scripts\validate_plugin.py'
python $validatePlugin .\plugins\azure-workflow

pwsh -NoLogo -NoProfile -File .\scripts\Invoke-RepoCheck.ps1
```

Each skill is also validated independently with `skill-creator/scripts/quick_validate.py`.
