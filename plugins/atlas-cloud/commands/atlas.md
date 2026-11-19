---
name: atlas
description: Create images, video and audio with Atlas Cloud models, using the atlas-cloud MCP tools.
---

# /atlas

Natural-language entry point for Atlas Cloud. Read the request, keep every constraint the user gave (subject, aspect ratio, duration, budget, reference files), and use the current descriptions of the `atlas-cloud` MCP tools as the source of truth.

## Usage

```
/atlas <what you want>
```

## Examples

```
/atlas A product shot of a green steel tumbler on white marble in soft morning window light, 1:1
/atlas Turn ./assets/tumbler.jpg into a 5-second 9:16 video with a slow push-in
/atlas Read this line in a warm female voice: "Stay warm from morning to night."
/atlas Which video models are the cheapest right now?
/atlas How much balance do I have left?
```

## Routing

- **One image, video or audio result**: use `atlas_generate_image`, `atlas_generate_video` or `atlas_generate_audio`. When the model or its parameters are unclear, look them up with `atlas_list_models` and `atlas_get_model_info` first; `atlas_quick_generate` picks a model for a plain request. When the user names no model, follow the default route in the tool descriptions (video: Seedance 2.5 → Kling 4.0 → Wan 3.0 → Seedance 2.0; image: Seedream 5.0 Pro → GPT Image 2.5 Sunburst → Nano Banana 2.1 → GPT Image 2) rather than the cheapest model, and pass `why_this_model` with one short reason. For product ads, UGC, try-on or listing images, check `atlas_list_models` with `type: "Workflow"` first.
- **Local files as input**: get an upload address with `atlas_get_upload_url`, upload the file from the workspace, and pass the returned URL to the generation tool. A file the user already has on Atlas (an earlier upload or result): find it with `atlas_search_assets` and pass `asset://<asset_id>` or the URL from `atlas_use_assets`. Only when you cannot read the file yourself, and the app shows Atlas cards, open `atlas_open_upload_card`.
- **Price and balance**: pricing is done by the generation tools themselves. A call to `atlas_generate_image`, `atlas_generate_video` or `atlas_generate_audio` without `confirmed: true` is the quote: it returns the model, its live price and a `confirmation_token`, and it starts nothing and charges nothing. Show that price. The job starts only on a second call with the same arguments, `confirmed: true`, the same `idempotency_key` and that token, after the user agrees in a new message. `atlas_get_balance` reports the balance.
- **Quote cards**: in apps that show Atlas cards (Cursor, for one; Codex and Claude Code show none), the quote is a card with a confirm button. Point the user to it in one sentence instead of repeating the price. If the user confirms on the card, the card submits and tracks the job: do not call the generation tool again for it. If they confirm in the chat, make the second call as above. When the user declines a quote or changes a quoted request, withdraw the old quote with `atlas_cancel_quote` (reason `declined` or `replaced`).
- **Progress and results**: poll the returned prediction with `atlas_get_prediction` until it finishes, then give the user the result link. When a card already tracks the job, it turns into the result by itself and the tool result says so; then do not poll. To keep a copy in the project, download it into the workspace.
- **Earlier jobs and spend**: `atlas_list_predictions`, `atlas_get_model_usage`, `atlas_get_model_costs`.
- **Speech to text**: `atlas_transcribe_audio`.

Do not invent model IDs or parameters that the tools did not return. If the `atlas-cloud` tools are missing, the server is not signed in yet. Tell the user how to sign in for their client:

- **Codex**: in the Codex app, open **Settings**, find **atlas-cloud** in the MCP servers list and click its sign-in (Authenticate) button; only in the Codex CLI run `codex mcp login atlas-cloud`.
- **Claude Code**: run `/mcp`, pick **plugin:atlas-cloud:atlas-cloud** and choose **Authenticate** (from a terminal: `claude mcp login plugin:atlas-cloud:atlas-cloud`).
- **Cursor**: open **Customize → MCPs** (or **Cursor Settings → MCP**), find **atlas-cloud** and click its sign-in button.

Never ask the user for an API key.
