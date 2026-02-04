# Project

This command starts a new project.

## Input

**Project name** (user provides it, e.g. after `/project My Project`). Normalize it as follows:

- Convert to lowercase.
- Replace any character that is not a letter, digit, or hyphen with a dash (`-`).
- Replace any sequence of one or more dashes (or other replaced characters) with a **single** dash.

Examples: `Test > > > Project` → `test-project`; `My  Cool   App` → `my-cool-app`.

Use this normalized string as **project name** for all steps below (session name, work-directory segment, etc.).

**Branch name** (only used when inside a git repository): Ask the user for the name of the branch to create for this project. **Default:** the user's project name input, normalized for branch names. When using that default, **preserve `/`** in the branch name and normalize the rest the same way as for project name (lowercase; replace any character that is not a letter, digit, hyphen, or `/` with a dash; collapse runs of dashes to a single dash). Example: `/project test/foo-bar` → project name `test-foo-bar`, branch name `test/foo-bar`. Use this **branch name** in step 1 when creating the worktree.

---

## Workflow

### 1. Work directory

- **If the current directory is inside a git repository:** Create a **new branch** and a **new worktree** at `~/src/corp/work/<repository>/<project>`, where `<repository>` is the name of the repository root (e.g. from `basename $(git rev-parse --show-toplevel)`). This path is the **work directory**. Create the branch and worktree in one step, e.g. `git worktree add -b <branch-name> <work-directory>`. The worktree will be on the new branch.
- **If not in a git repository:** The **work directory** is the current directory.

### 2. Tmux session

- Start a **new tmux session** named after the project (use the normalized project name as session name).
- If a session with that name **already exists**, do **not** create it. Return an error to the user and ask for instructions (e.g. suggest choosing a different project name or renaming/ending the existing session).
- Create the session with its working directory set to the work directory from step 1.

  **Note:** The tmux MCP `create-session` tool only accepts a session name, not a working directory. Use the tmux CLI to set both:

  ```bash
  tmux new-session -d -c <work-directory> -s <project-name>
  ```

  (`-d` creates the session detached so you can continue configuring it.)

### 3. Two panes (agent + exec)

- In that session's first window, ensure there are **two panes**, split **vertically** (left and right).
- **Left pane** = "agent" pane (where the Cursor agent will run).
- **Right pane** = "exec" pane (for running commands from the agent).

  **Preferred: tmux MCP** — If the tmux MCP server is available, use it: `list-windows` for the session (by ID from `find-session` by project name), then `list-panes` for the first window to get the single pane's ID. Call `split-pane` with that pane ID and `direction: "horizontal"` (left/right) to create the second pane. The original pane stays left (agent), the new pane is right (exec).

  **Fallback: tmux CLI** — If the tmux MCP server is not available, split the only pane with:

  ```bash
  tmux split-window -h -t <project-name>:0
  ```

  so that the left pane is the original and the right is the new one.

- **Select the agent pane** so it is focused when the user attaches to the session. By default, tmux selects the last-created pane (the exec pane), so explicitly switch focus to the agent pane.

  **Note:** The tmux MCP server does not have a `select-pane` tool. Use the tmux CLI:

  ```bash
  tmux select-pane -t <project-name>:0.0
  ```

### 4. Start agent in agent pane with initial context

The Cursor agent CLI accepts an initial prompt as its first positional argument: `agent "<prompt>"`. Use this to provide the agent with tmux context immediately upon startup.

#### 4a. Construct the initial prompt

Build a prompt string containing:
- The agent is running **inside tmux**.
- The **session name** (the normalized project name).
- It is in the **agent pane** (left pane) — include the pane ID.
- It must run all commands in the **exec pane** (right pane) — include the pane ID.
- It should prefer the **tmux MCP server** over CLI commands, if available.

The pane IDs come from step 3:
- **Agent pane ID:** The original pane before splitting (MCP: `%<id>`, CLI target: `<project-name>:0.0`).
- **Exec pane ID:** The new pane created by the split (MCP: `%<id>`, CLI target: `<project-name>:0.1`).

**Template:**
```
You are running inside tmux. Session: <project-name>. You are in the agent pane (left, ID: <agent-pane-id>). Run all shell commands in the exec pane (right, ID: <exec-pane-id>). Prefer using the tmux MCP server over CLI commands when available.
```

**Concrete example** (for project name `my-app`, agent pane `%5`, exec pane `%6`):
```
You are running inside tmux. Session: my-app. You are in the agent pane (left, ID: %5). Run all shell commands in the exec pane (right, ID: %6). Prefer using the tmux MCP server over CLI commands when available.
```

**Fallback example** (CLI targets when MCP is not available):
```
You are running inside tmux. Session: my-app. You are in the agent pane (left, target: my-app:0.0). Run all shell commands in the exec pane (right, target: my-app:0.1). Prefer using the tmux MCP server over CLI commands when available.
```

#### 4b. Execute the agent command in the agent pane

**Preferred: tmux MCP** — If the tmux MCP server is available, use the `execute-command` tool:

- `paneId`: the agent pane ID from step 3 (e.g. `%5`)
- `command`: the full agent command with prompt, e.g.:
  ```
  agent "You are running inside tmux. Session: my-app. You are in the agent pane (left, ID: %5). Run all shell commands in the exec pane (right, ID: %6). Prefer using the tmux MCP server over CLI commands when available."
  ```
- `rawMode`: `true` (the agent is an interactive application)

The `execute-command` tool runs the command and presses Enter automatically.

**Fallback: tmux CLI** — If the tmux MCP server is not available:

```bash
tmux send-keys -t my-app:0.0 'agent "You are running inside tmux. Session: my-app. You are in the agent pane (left, target: my-app:0.0). Run all shell commands in the exec pane (right, target: my-app:0.1). Prefer using the tmux MCP server over CLI commands when available."' Enter
```

- Target `<project-name>:0.0` refers to session `<project-name>`, window `0`, pane `0` (the left/agent pane).
- Use single quotes around the entire command to preserve the double quotes inside.
- If the prompt contains single quotes, escape them as `'\''`.

---

## End of workflow

After step 4, the workflow is complete. The agent is running with full context about its tmux environment. The user can attach to the session with `tmux attach -t <project-name>` if needed.
