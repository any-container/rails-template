---
name: extract
description: Version 2 skill, new in V2: lift content from an existing Rails code base, merged PR or commit range into a new injectable feature, or into the next version of an existing feature or skill. Use when the user wants to extract, abstract or version existing content into features/.
---

# Extract

Version 2 of the skill set adds `extract`. It turns content that already exists in a Rails code base (a merged PR, commit range, branch or folder) into an injectable feature in `features/`, or into the next version of an existing feature or skill. This is the `extract` verb in `workflows/features.md`: it enters the lifecycle at the same state as `build`, skipping draft.

## Inputs

Confirm all three with the user before writing anything:
- **Source:** a PR number, commit range, branch or path. "The last merged PR" resolves to a concrete PR number first.
- **Target:** a feature or skill name.
- **Intent:** `new` (version 1 of a new feature) or `version` (version N+1 of an existing one).

## Steps

1. Read `features/CONTEXT.md` and list `features/`. Check whether the target already exists. If it does and intent is `new`, stop and ask. If it does not exist and intent is `version`, stop and ask.
2. Diff the source against its base. List the changed files and group them: content that belongs in the feature, and content that is specific to the source app.
3. Show the grouping to the user and get confirmation of scope. Leave out anything the user excludes.
4. Abstract the content: replace app-specific names, values and paths with template parameters or host edits in `template.rb`. Host-owned files never go in `files/`.
5. If intent is `new`, build the feature with the `new-feature-V2` skill from step 3 onward, using the abstracted content as input.
6. If intent is `version`, archive first (see Versioning above), then replace the feature's contents in place and set the new version in `FEATURE.md`.
7. Verify as `new-feature-V2` step 7 requires: inject into a scratch copy of a `rails-api/` template app, migrate, run specs, and run the template twice. Do not mark the extraction done on a failing run.
8. Open a GitHub ticket for the feature. Open a PR whose description says `Refs #<ticket>` (not `Closes`). Label the ticket `ready-for-human`.

## Versioning

Read the "Versioning" section at the bottom of `features/CONTEXT.md` to understand what to do for versioning changes.

## Rules

- Never edit the source repo or branch. Read only.
- Do not extract secrets, credentials or environment-specific values. Replace them with configuration documented in `FEATURE.md`.
- Do not delete or overwrite a previous version. Archive it first.
- Report a very brief summary of the changes and a list of all file names moved.
