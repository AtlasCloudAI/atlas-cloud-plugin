<h1 align="center">Atlas Cloud plugin for Codex and Cursor</h1>

<p align="center">
  Generate images, video and audio with 300+ models from inside Codex, Cursor and Grok Bot.<br>
  Sign in once in the browser — no API key to copy or paste, and generation is billed to your own Atlas account.
</p>

## Install in Codex

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

## Install in Cursor

**Cursor Marketplace** (once the listing is approved): type `/add-plugin` in the Cursor chat,
search for **Atlas Cloud** and install it.

**From source**: Cursor loads local plugins from `~/.cursor/plugins/local/<plugin-name>/`.

```bash
git clone https://github.com/AtlasCloudAI/atlas-cloud-plugin.git
mkdir -p ~/.cursor/plugins/local
rsync -a --delete atlas-cloud-plugin/plugins/atlas-cloud/ ~/.cursor/plugins/local/atlas-cloud/
```

Then run **Developer: Reload Window** from the command palette. **Customize → Plugins** should
list **Atlas Cloud**, and **Customize → MCPs** should list **atlas-cloud**.

If you added `https://mcp.atlascloud.ai/mcp` to `~/.cursor/mcp.json` by hand before, remove that
entry so the server is not listed twice.

## Install in Grok Bot

Grok Bot uses the Cursor plugin. Open **Connect apps**, search for **Atlas Cloud** and add it
(once the Cursor listing is approved). Until then, send this in a Grok Bot chat:

```
/add-connector https://mcp.atlascloud.ai/mcp
```

## Sign in

The first Atlas tool call, or the sign-in button next to **atlas-cloud** in **Customize → MCPs**
(Cursor) or the plugin page (Codex), opens the Atlas sign-in page in your browser. Approve access
once; after that the connection stays authorized. Generation is billed to that Atlas account, and
you never paste an API key.

## Try it

In Cursor, start with `/atlas`, or just ask in plain words:

1. **Product photo**: `/atlas A product shot of a green steel tumbler on white marble in soft morning window light, 1:1`
2. **Reference image to video**: `/atlas Turn ./assets/product.jpg into a 5-second 9:16 video with a slow push-in`
3. **UGC-style ad**: `/atlas Make a short UGC-style ad for ./assets/product.jpg with the atlascloud/studio/ugc-ad workflow`

Each request comes back first with the model and its live price. Nothing runs, and nothing is
billed, until you say go.

## Troubleshooting

| What you see | What to do |
|---|---|
| No Atlas tools in the chat | Open **Customize → MCPs**, find **atlas-cloud** and click its sign-in button, then start a new chat. |
| The sign-in page says **Cursor** wants to access your account | Expected in Grok Bot: it signs in through Cursor. |
| "Insufficient balance" | Top up in the [Atlas console](https://www.atlascloud.ai/console), then ask again. |
| A video preview does not load in the chat | Open the result link, or ask the agent to download the file into the workspace. |
| The server is listed twice | Remove the hand-added `atlas-cloud` entry from `~/.cursor/mcp.json`. |

Need help? Open an [issue](https://github.com/AtlasCloudAI/atlas-cloud-plugin/issues) or write to
support@atlascloud.ai.

## What you get

| | |
|---|---|
| **atlas-cloud** (MCP server) | Browse the live model catalog and run image, video, audio and transcription jobs from chat. Every job first shows the model and its live price, and runs only after you say yes. |
| **Media Generation** (skill) | How to call Atlas from your own project — endpoints, auth, polling. This route uses your own API key. |
| **Seedance** (skill) | Storyboard-driven Seedance video: consistent people, products and scenes, reference-to-video, extensions. |
| **Universal Video Prompt** (skill) | One model-agnostic prompt spec, compiled to whichever video model you can actually call. |
| **/atlas** (Cursor command) | Plain-language entry point that routes a request to the right Atlas tool. |

> The MCP server is named `atlas-cloud`, not `Atlas Cloud`. Codex validates server
> names against `^[a-zA-Z0-9_:@/.-]+$` when it launches one, so a space fails to
> start — and it fails at launch, not at config load, so `codex mcp list` will
> happily show a name that never connects.

## One plugin, several hosts

`plugins/atlas-cloud` is installed by every host from the same files. Each host reads its own
manifest and ignores the others:

| Host | Marketplace manifest | Plugin manifest | MCP config |
|---|---|---|---|
| Codex | `.agents/plugins/marketplace.json` | `.codex-plugin/plugin.json` | `.mcp.json` |
| Cursor, Grok Bot | `.cursor-plugin/marketplace.json` | `.cursor-plugin/plugin.json` | `mcp.json` |

The skills under `skills/` are shared. Keep the server URL in `.mcp.json` and `mcp.json` the same,
and bump the version in both plugin manifests together: hosts use it to decide when to refresh.

## Where the skills come from

The skills are maintained in [AtlasCloudAI/atlas-cloud-skills](https://github.com/AtlasCloudAI/atlas-cloud-skills);
this repository carries copies of them. Codex does not follow symlinks when it installs a plugin —
a symlinked `skills/` directory installs empty, with no error — so the copies are real files, and
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
