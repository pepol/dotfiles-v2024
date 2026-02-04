# Commit

Create a git commit with **all current changes** (stage any unstaged changes, then commit). When using the git CLI (fallback), run those commands in the other tmux pane (create it with a vertical split if it does not exist).

## Steps

1. **Stage everything**  
   Include both staged and unstaged changes in the commit.

2. **Infer commit message style**  
   From the repo’s existing history, determine the usual style (e.g. `scope: short imperative message`, lowercase, no trailing period).

3. **Summarize what’s being committed**  
   Inspect what will be committed and summarize it in one short line that matches the repo’s style.

4. **Commit with the generated message**  
   Create the commit using the single-line message from step 3. If the repo uses a strict convention (e.g. all lowercase), follow it exactly.

Do not ask for confirmation of the message; generate it and run the commit. If there is nothing to commit, report that and do nothing.

---

## Preferred: Git MCP server

When the **Git MCP server** is available, use its tools for all steps (no tmux pane required):

- **Status and diffs:** `git_status`, `git_diff_unstaged`, `git_diff_staged` (after staging) to see what will be committed.
- **History / style:** `git_log` with a suitable `max_count` (e.g. 15–20) to infer commit message style.
- **Stage all:** `git_add` with `files: ["."]` or the list of changed files from status so all current changes are staged.
- **Commit:** `git_commit` with `message` set to the generated single-line message.

Use the repo path from the workspace (e.g. the project root or the path returned by git tools).

## Fallback: git CLI

When the Git MCP server is **not** available, run these in the **other tmux pane** (create it with a vertical split if needed):

1. **Stage:** `git add -A` (or `git add .`) in the repository root.
2. **Style:** `git log -20 --oneline` or `git log -10` to infer message style.
3. **Changes:** `git status`, `git diff --staged` (and `git diff` before staging if needed).
4. **Commit:** `git commit -m "<generated message>"`.
