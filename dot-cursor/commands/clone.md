# Clone

Clone a Git repository from GitHub via SSH into a predefined directory based on the organization.

## Input

**Repository** (user provides it after `/clone`, e.g. `/clone pepol/dotfiles-v2024` or `/clone acme/my-app`).

Format: `<organization>/<repository>`, or just `<repository>`.

- **Organization** — the GitHub user or org (e.g. `pepol`, `acme`). **If not provided** (e.g. `/clone foo` with no slash), default to **`pepol`** — so `/clone foo` means clone `pepol/foo`.
- **Repository** — the repo name; this is also the **directory name** where the repo will be cloned (no path, just the name).

## Rules

1. **Clone URL:** Always use SSH: `git@github.com:<organization>/<repository>.git`.

2. **Target directory:**
   - If `<organization>` is **`pepol`** → clone into `~/src/personal/<repository>`.
   - For any other organization → clone into `~/src/corp/<repository>`.

3. **Directory name:** Use only `<repository>` (the part after the slash). The full path is the base folder above plus `<repository>`.

## Steps

1. **Parse input**  
   From the text after `/clone`, extract `<organization>` and `<repository>`. Trim whitespace. If the value contains a `/`, split into organization and repository (both non-empty). If it contains no `/`, treat the whole value as `<repository>` and set `<organization>` to **`pepol`**.

2. **Determine base path**  
   - `pepol` → base = `~/src/personal/`  
   - Other → base = `~/src/corp/`

3. **Full target path**  
   Target = base + `<repository>` (e.g. `~/src/personal/dotfiles-v2024` or `~/src/corp/my-app`).

4. **Clone**  
   Prefer the Git MCP server if it provides a clone function; otherwise run `git clone` in the other tmux pane (create a vertical split if it does not exist). See below.

5. **Result**  
   Tell the user the repo was cloned and the path where it lives. If the directory already exists or clone fails, report the error and do not overwrite.

---

## Preferred: Git MCP server

When the **Git MCP server** is available and provides a **clone** function, use it to clone the repository:

- **URL:** `git@github.com:<organization>/<repository>.git`
- **Target path:** the full path from step 3 (expand `~` to the user’s home directory).

If the Git MCP server does not expose a clone function, use the fallback below.

## Fallback: tmux + git CLI

When the Git MCP server is **not** available or does **not** provide a clone function, run the clone in the **other tmux pane** (create a vertical split if it does not exist):

```bash
git clone git@github.com:<organization>/<repository>.git <target-path>
```

Use the user’s home directory for `~` in the target path (e.g. `$HOME` or equivalent). If you are in a session with an “agent” and “exec” pane layout, run this in the **exec** (right) pane.

---

Do not ask for confirmation; parse the input, compute the path, and run the clone. If the user provided nothing after `/clone`, ask for the repository (and optionally organization, or omit for default `pepol`).
