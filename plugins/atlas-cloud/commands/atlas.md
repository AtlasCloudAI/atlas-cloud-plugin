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

- **One image, video or audio result**: use `atlas_generate_image`, `atlas_generate_video` or `atlas_generate_audio`. When the model or its parameters are unclear, look them up with `atlas_list_models` and `atlas_get_model_info` first; `atlas_quick_generate` picks a model for a plain request.
- **Local files as input**: get an upload address with `atlas_get_upload_url`, upload the file from the workspace, and pass the returned URL to the generation tool.
- **Price and balance**: pricing is done by the generation tools themselves. A call to `atlas_generate_image`, `atlas_generate_video` or `atlas_generate_audio` without `confirmed: true` is the quote: it returns the model, its live price and a `confirmation_token`, and it starts nothing and charges nothing. Show that price. The job starts only on a second call with the same arguments, `confirmed: true` and that token, after the user agrees. `atlas_get_balance` reports the balance.
- **Progress and results**: poll the returned prediction with `atlas_get_prediction` until it finishes, then give the user the result link. To keep a copy in the project, download it into the workspace.
- **Earlier jobs and spend**: `atlas_list_predictions`, `atlas_get_model_usage`, `atlas_get_model_costs`.
- **Speech to text**: `atlas_transcribe_audio`.

Do not invent model IDs or parameters that the tools did not return. If the `atlas-cloud` tools are missing, the server is not signed in yet: open the MCP settings (in Cursor, **Customize → MCPs** or **Cursor Settings → MCP**), find **atlas-cloud** and click its sign-in button. Never ask the user for an API key.
