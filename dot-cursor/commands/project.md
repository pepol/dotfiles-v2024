# Project

This command starts a new project.

## Input

**Project name** (user provides it, e.g. after `/project My Project`). Normalize it as follows:

- Convert to lowercase.
- Replace any character that is not a letter, digit, or hyphen with a dash (`-`).
- Replace any sequence of one or more dashes (or other replaced characters) with a **single** dash.

Examples: `Test > > > Project` → `test-project`; `My  Cool   App` → `my-cool-app`.

Use this normalized string as **project name** for all steps below (session name, work-directory segment, etc.).

**Branch name** (only used when inside a git repository): Ask the user for the name of the branch to create for this project. **Default:** the user’s project name input, normalized for branch names. When using that default, **preserve `/`** in the branch name and normalize the rest the same way as for project name (lowercase; replace any character that is not a letter, digit, hyphen, or `/` with a dash; collapse runs of dashes to a single dash). Example: `/project test/foo-bar` → project name `test-foo-bar`, branch name `test/foo-bar`. Use this **branch name** in step 1 when creating the worktree.

---

## Workflow

### 1. Work directory

- **If the current directory is inside a git repository:** Create a **new branch** and a **new worktree** at `~/src/corp/work/<repository>/<project>`, where `<repository>` is the name of the repository root (e.g. from `basename $(git rev-parse --show-toplevel)`). This path is the **work directory**. Create the branch and worktree in one step, e.g. `git worktree add -b <branch-name> <work-directory>`. The worktree will be on the new branch.
- **If not in a git repository:** The **work directory** is the current directory.

### 2. Tmux session

- Start a **new tmux session** named after the project (use the normalized project name as session name).
- If a session with that name **already exists**, do **not** create it. Return an error to the user and ask for instructions (e.g. suggest choosing a different project name or renaming/ending the existing session).
- Create the session with its working directory set to the work directory from step 1. Use the tmux CLI:

  ```bash
  tmux new-session -d -c <work-directory> -s <project-name>
  ```

  (`-d` creates the session detached so you can continue configuring it.)

### 3. Two panes (agent + exec)

- In that session’s first window, ensure there are **two panes**, split **vertically** (left and right).
- **Left pane** = “agent” pane (where the Cursor agent will run).
- **Right pane** = “exec” pane (for running commands from the agent).

  **Preferred: tmux MCP** — If the tmux MCP server is available, use it: `list-windows` for the session (by ID from `find-session` by project name), then `list-panes` for the first window to get the single pane’s ID. Call `split-pane` with that pane ID and `direction: "horizontal"` (left/right) to create the second pane. The original pane stays left (agent), the new pane is right (exec).

  **Fallback: tmux CLI** — If the tmux MCP server is not available, split the only pane with:

  ```bash
  tmux split-window -h -t <project-name>:0
  ```

  so that the left pane is the original and the right is the new one.

  Ensure that when user is attaching to the session, the agent pane will be selected. By default tmux selects last created pane, i.e. the exec pane, so switch focus.

### 4. Start agent in agent pane

- In the **agent** (left) pane, start a new Cursor agent with the command:

  ```bash
  agent
  ```

  Use the tmux CLI to send this to the agent pane, e.g.:

  ```bash
  tmux send-keys -t <project-name>:0.0 'agent' Enter
  ```

  (Adjust the target `0.0` if your pane indices differ; left pane is typically `0.0`.)

### 5. Instruct the agent

- Once the agent is running in the agent pane, give it clear context in one message:
  - It is running **inside tmux**.
  - **Session name:** `<project-name>`.
  - **Current pane:** the **agent** pane (left).
  - **Exec pane:** the **right** pane; the agent must use this pane for **any** commands it runs (shell commands, git, etc.).

  Ask the user to continue in that agent chat, or copy this instruction into the agent’s first message so it adopts this behavior.

---

## End of workflow

After step 5, the workflow is complete. The user can attach to the session with `tmux attach -t <project-name>` if needed.
