# Agentic Foundry

Relational index of layers. A layer is one end-to-end feature implementation, committed together; its git commit SHA is its id.

## Front matter

Any file a commit touches under `features/` may carry YAML front matter:

    ---
    name: feature_registry
    parents: [other_layer]    # must already be registered
    siblings: [another_layer] # must already be registered; one-way
    ---

`children` is not written by hand. It is filled in when a child registers.

## Registration

PRs labelled `layer` run `.github/workflows/create-layer.yml`. It runs `ruby foundry/register_layer.rb <head sha>`, commits `foundry/foundry.sqlite3` to the PR branch, and comments the short SHA with success or failure.

Local run: `gem install sqlite3 && ruby foundry/register_layer.rb`.
