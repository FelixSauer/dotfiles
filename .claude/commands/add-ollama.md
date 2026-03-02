---
description: Add an Ollama model — Modelfile and opencode.json entry
argument-hint: <model:tag>
allowed-tools: WebFetch, Bash, Read, Edit, Write
---

You are adding a new Ollama model to the dotfiles project. The argument is: $ARGUMENTS

The argument format is `model:tag` (e.g. `mistral:7b`, `qwen2.5:14b`).

## Step 1 — Identify the model family

Parse the model name to determine the template family:
- `llama` / `llama3` → Llama chat template (uses `<|start_header_id|>` tokens)
- `qwen` → ChatML template (uses `<|im_start|>` tokens)
- `deepseek` → DeepSeek template (uses `<|begin_of_sentence|>` tokens; add `"reasoning": true` in opencode.json if it's an R1/reasoning model)
- `mistral` / `mixtral` → Mistral template (uses `[INST]` / `[/INST]` tokens)
- `gemma` → Gemma template (uses `<start_of_turn>` tokens)
- Other → use generic ChatML as fallback

To confirm the exact template syntax, check an existing Modelfile in `ollama/` for the closest family match.

## Step 2 — Read existing files

Read all existing Modelfiles in `ollama/` to use as templates:
- `ollama/llama3.2-3b.Modelfile`
- `ollama/qwen2.5-coder-32b.Modelfile`
- `ollama/deepseek-r1-32b.Modelfile`

Read `opencode/.config/opencode/opencode.json` to understand the current model list.

## Step 3 — Create the Modelfile

Create `ollama/<model-name>-<tag>.Modelfile` (replace `:` with `-` in the filename).

Base the content on the closest existing Modelfile. Adjust:
- `FROM <model:tag>` line at the top
- Keep `num_ctx 32768` unless the model is known to support larger context
- Match the TEMPLATE and stop tokens to the correct family
- Keep the SYSTEM prompt identical to existing models

Example filename: `mistral-7b.Modelfile` for `mistral:7b`

## Step 4 — Update opencode.json

Read the current `opencode/.config/opencode/opencode.json` and add a new entry under
`provider.ollama.models`:

```json
"<model:tag>": { "name": "<Human Readable Name>", "tool_call": true }
```

For reasoning/R1 models also add `"reasoning": true`.

Keep the JSON valid and follow the existing indentation style (2-space indent).

## Step 5 — Verify (optional)

If `ollama` is available locally, you can run:
```bash
ollama show <model:tag>
```
to confirm the model exists in the registry before creating files.

After completing all steps, summarize:
- Modelfile path created
- opencode.json entry added
- Model family / template used
