# Agentic Foundry

Relational index of layers. A layer is one end-to-end feature implementation, committed together; its git commit SHA is its id.

## Front matter

Layer files use [OKF v0.2](https://github.com/GoogleCloudPlatform/open-knowledge-format) front matter. `type: Layer` marks a layer file; `layer`, `parents` and `siblings` are OKF extension keys.

    ---
    type: Layer
    title: Feature Registry
    description: Per-deployment feature toggles.
    tags: [feature]
    layer: feature_registry        # layer name, required
    parents: [other_layer]         # names; must already be registered (earlier commit)
    siblings: [another_layer]      # names; must already be registered; one-way
    generated: { by: human:thom, at: 2026-11-05T00:00:00Z }
    status: stable
    ---

Only files with `type: Layer` register. Payload files under `features/<name>/files/` are copied into host apps and carry no layer front matter. `children` is not written by hand; it is filled in when a child registers. A parent must be registered in an earlier commit than its child.

## Registration

PRs labelled `layer` run `.github/workflows/create-layer.yml`. It runs `ruby foundry/register_layer.rb <head sha>`, commits `foundry/foundry.sqlite3` to the PR branch, and comments the short SHA with success or failure.

Local run: `gem install sqlite3 && ruby foundry/register_layer.rb`.
