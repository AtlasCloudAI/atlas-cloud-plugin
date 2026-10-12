<h1 align="center">Atlas Cloud plugin for Codex and Claude Code</h1>

<p align="center">
  Generate images, video and audio with 300+ models from inside Codex or Claude Code.<br>
  Sign in once in the browser — no API key to copy or paste, and generation is billed to your own Atlas account.
</p>

## Install

### Codex

In the ChatGPT desktop app: **Settings → Plugins → Add → Add plugin marketplace**, source
`AtlasCloudAI/atlas-cloud-plugin`, leave the other two fields empty. Then open **Atlas Cloud**
in the list and click **Install plugin**.

Or from a terminal:

```bash
codex plugin marketplace add AtlasCloudAI/atlas-cloud-plugin
codex plugin add atlas-cloud@atlas-cloud
codex mcp login atlas-cloud
```

Turn on the **atlas-cloud** MCP server on the plugin page. The first time you do, a browser opens
to sign in and approve; after that it stays authorized.

### Claude Code

```text
/plugin marketplace add AtlasCloudAI/atlas-cloud-plugin
/plugin install atlas-cloud@atlas-cloud
```

Then run `/mcp`, pick **plugin:atlas-cloud:atlas-cloud** and choose **Authenticate**. A browser
opens to sign in and approve; after that it stays authorized.

The same steps work from a terminal:

```bash
claude plugin marketplace add AtlasCloudAI/atlas-cloud-plugin
claude plugin install atlas-cloud@atlas-cloud
claude mcp login plugin:atlas-cloud:atlas-cloud
```

## What you get

| | |
|---|---|
| **atlas-cloud** (MCP server) | Browse the live model catalog and run image, video, audio and transcription jobs from chat. Small jobs run straight away; only an expensive one stops to quote a price and wait for your go-ahead. |
| **Media Generation** (skill) | How to call Atlas from your own project — endpoints, auth, polling. This route uses your own API key. |
| **Seedance** (skill) | Storyboard-driven Seedance video: consistent people, products and scenes, reference-to-video, extensions. |
| **Universal Video Prompt** (skill) | One model-agnostic prompt spec, compiled to whichever video model you can actually call. |

> The MCP server is named `atlas-cloud`, not `Atlas Cloud`. Codex validates server
> names against `^[a-zA-Z0-9_:@/.-]+$` when it launches one, so a space fails to
> start — and it fails at launch, not at config load, so `codex mcp list` will
> happily show a name that never connects.

## One plugin, two manifests

Both hosts install the same `plugins/atlas-cloud` directory. Codex reads
`.agents/plugins/marketplace.json` and `.codex-plugin/plugin.json`; Claude Code reads
`.claude-plugin/marketplace.json` and `plugins/atlas-cloud/.claude-plugin/plugin.json`. The skills
and `.mcp.json` are shared.

`.mcp.json` sets `"type": "http"` on the server. Claude Code needs it: an entry with only a `url`
is parsed as a stdio server, fails for lacking a `command`, and is dropped without an error. Codex
accepts the field and still connects over streamable HTTP. Keep the version in both `plugin.json`
files in step — each host uses it to decide whether an installed copy is stale.

## Where the skills come from

The skills are maintained in [AtlasCloudAI/atlas-cloud-skills](https://github.com/AtlasCloudAI/atlas-cloud-skills);
this repository carries copies of them. Codex does not follow symlinks when it installs a plugin —
a symlinked `skills/` directory installs empty, with no error — and Claude's plugin directory
rejects symlinks outright, so the copies are real files, and
`sync-skills.sh` regenerates them from the source repository:

```bash
bash sync-skills.sh
```

Two of them are renamed on the way in. Codex derives every visible label from the identifier, and
identifiers allow only lowercase letters, digits and hyphens: `atlas-cloud` reads better as
`media-generation` next to a plugin already called Atlas Cloud, and `seedance-2-5-skill` would
render as "Seedance 2 5" because the dot cannot survive.

## Links

- [Atlas Cloud](https://www.atlascloud.ai/) · [models](https://www.atlascloud.ai/models) · [console](https://www.atlascloud.ai/console)
- [Skills repository](https://github.com/AtlasCloudAI/atlas-cloud-skills)
