## Folder structure
The project structure should be as in the image below:

![image](https://github.com/user-attachments/assets/400932c2-5232-4b4f-9ca9-83ad9d2dd876)

Each feature should have its own folder under the `/features` folder and then the presentation, state management and models should be divided into their own files/sub-folders. Any shared files/folders should be put in the `/shared` folder in the root of the project.
If there are multiple sub-features within a feature, then those sub-features should have its own folder underneath the main feature folder. For example: `/features/auth/registration` and `/features/auth/login`
## Issues
Every major change/functionality should have a seperate issue so that we can easily track progress and assign the issue to one of the group members.

## Git branches
Every major change or added functionality should have its own git brach made from a copy of main (or dev if its latest changes are stable).

If possible, the branch should mention what type of change it is (feature, bugfix, hotfix, refactor etc.) and also the issue number if it has a issue.
Examples for branch names:
- `feature/{issue-number}-{short-description}`
- `bugfix/{issue-number}-{short-description}`
- `hotfix/{short-description}`
- `issue/{issue-number}-{description}`
## Pull requests
When merging into main or dev/test you should always create a pull request unless it is a very small hotfix that has no chance of breaking code.
Create a pull request (PR) from your branch into dev and then write a small description about what was added/changed and possibly why.

Each PR should be linked to an issue so that when the PR is accepted and merged, the issue will be closed automatically. eg. `closes #1` to close issue number 1 ([How to link issues to PRs](https://docs.github.com/en/issues/tracking-your-work-with-issues/using-issues/linking-a-pull-request-to-an-issue#linking-a-pull-request-to-an-issue-using-a-keyword)).

When creating a PR, you should also set one of the other group members as a reviewer. The reviewer should then look over the code, propose any potential changes, and then approve it when all changes has been made. When all reviewers have approved the PR, the PR can be merged into main/dev.
