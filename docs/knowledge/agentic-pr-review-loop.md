# Agentic PR review loop

## Purpose

Capture a practical pattern for using two coding agents as separate engineering
roles: one agent builds, another reviews, CI supplies objective checks, and the
pull request keeps the audit trail visible.

Short version:

```text
Builder writes. Reviewer reviews. CI arbitrates. The PR decides.
```

## When to use this pattern

Use this pattern when AI agents are allowed to open or update pull requests and
the repository needs a stronger quality gate than "the same agent says it is
done."

It fits best when:

- CI exists and covers the important runtime paths.
- PR comments are treated as the visible record of review decisions.
- The team wants builder momentum without letting the builder bypass review.
- The reviewing agent can inspect diffs, CI state, logs, comments, and tests.

## Minimum viable workflow

1. A builder agent implements the change, pushes the branch, and opens the PR.
2. CI runs the objective checks.
3. A reviewer agent inspects the PR independently.
4. The reviewer posts either `Not LGTM yet` with concrete blockers or `LGTM`
   for the exact head commit.
5. The builder fixes feedback and pushes a new commit.
6. Any new commit invalidates the previous approval.

The important rule:

```text
LGTM is attached to a commit, not to a feeling.
```

## Builder prompt template

Use this for Claude Code or any agent responsible for writing code:

```text
You may write code, push branches, and open PRs. Do not merge before the review
gate passes.

After opening or updating a PR:
1. Push the branch.
2. Wait for CI to start and finish.
3. Wait for the independent PR-review automation.

A PR is mergeable only when an automation-authored comment on the PR says:

LGTM
<!-- codex-pr-review: <head_sha> -->

The marker must match the current PR head SHA. If a new commit is pushed, any
older LGTM is stale.

You are authorized to merge after the review gate passes. Immediately before
merging, re-fetch the PR head SHA, CI state, comments, and reviews. Merge only
if CI is green, the marker matches the current head SHA, and no newer blocking
feedback exists. Otherwise report that the PR is ready but unmerged.

If the reviewer comments "Not LGTM yet":
1. Treat it as blocking feedback.
2. Fix the issue in code, tests, docs, or config.
3. Run relevant local checks.
4. Push a follow-up commit.
5. Reply on the PR with what changed.
6. Wait for review again.

Do not post LGTM yourself. Keep review and fix discussion visible on the PR.
```

## Reviewer prompt template

Use this for Codex or any agent responsible for independent review:

```text
Review open pull requests in the current repository.

For each open non-draft PR:
1. Fetch metadata, head SHA, changed files, patch, comments, reviews, and CI.
2. Ignore this automation's own comments except for detecting:
   <!-- codex-pr-review: <head_sha> -->
3. If CI is pending, do not post LGTM.
4. If CI failed, inspect failed jobs/logs and post one "Not LGTM yet" comment
   with the blocking check, likely root cause, concrete next fix, and marker.
5. If CI passed, review for bugs, regressions, deployment/runtime risks,
   security issues, tenant/user isolation issues, and missing tests.
6. If there are findings, post one "Not LGTM yet" comment with actionable
   findings and the marker.
7. If there are no findings and CI is green, post exactly:

LGTM
<!-- codex-pr-review: <head_sha> -->

Before posting, re-fetch the PR head SHA, CI state, and recent comments. Only
post if the head SHA is unchanged and no marker already exists for that SHA.

Do not merge PRs from the reviewer role. Do not enable auto-merge. Do not post
duplicate comments.
```

## Scheduler and race controls

For a polling reviewer, use a schedule that leaves room for CI and review work:

```text
RRULE:FREQ=MINUTELY;INTERVAL=5
```

Avoid one-minute polling unless reviews are guaranteed to finish in under a
minute. Overlapping runs can post duplicate or stale comments.

Use a repo-specific lock directory under `/private/tmp`:

```text
/private/tmp/codex-pr-review-<owner>-<repo>.lock
```

The reviewer should:

1. Create the lock directory atomically before GitHub work.
2. Exit quietly if the lock exists and is younger than the TTL.
3. Treat old locks as stale and replace them.
4. Remove the lock before exiting.

Use a separate repo-specific state file for polling state:

```text
/private/tmp/codex-pr-review-<owner>-<repo>-state.json
```

Store only compact state: repo, PR number, last head SHA, last CI state, last
marker SHA, and last significant event time. Do not store full patches, logs, or
repeated run summaries.

## Validation checklist

- [ ] The builder can merge after the review gate passes.
- [ ] The builder cannot merge before the gate.
- [ ] The reviewer never posts `LGTM` while CI is pending or failing.
- [ ] The review marker includes the exact head SHA.
- [ ] A new commit makes the prior marker stale.
- [ ] The reviewer ignores its own prior comments except for marker detection.
- [ ] The poller uses a lock and re-fetches PR state immediately before posting.
- [ ] Routine unchanged polls do not write noisy persistent memory.

## Anti-patterns

- Letting the builder approve its own PR.
- Treating `LGTM` as branch-level rather than commit-level.
- Posting approval before CI finishes.
- Having the reviewer respond to its own prior comments.
- Writing long persistent run notes for unchanged polling cycles.
- Hiding review findings in private chat instead of the PR.

## References

- `docs/ai-agent-coding-strategy.md` — human-facing strategy and layering model.
- `AGENTS.md` — baseline rules for agent behavior and PR hygiene.
- `docs/knowledge/README.md` — where descriptive notes live.

## Boundaries

This note describes a practical PR-review workflow. It does not define
repository-specific CI commands, branch protection rules, or merge authority.
Put repo-specific commands in that repository's `AGENTS.md`, `CLAUDE.md`, CI
workflows, or local automation configuration.
