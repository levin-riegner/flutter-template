# Contributing

## Development Workflow

1. Create a new branch from `master` to work on the new feature or changes.
1. Split your work into multiple atomic commits ([see guidelines](#commit-guidelines)).
1. Add unit tests to cover your changes.
1. Update the appropiate documentation in the [docs/](/docs/) folder if contributions contain project-wide motifications.
1. Open a `Pull Request` to `master` ([see guidelines](#pull-request-guidelines)).
1. Wait for approval and comments (ask teammates for review over slack if needed).
1. Merge the PR with a `merge commit`.

> ❗️ Always prioritize reviewing open PRs over working on your own to avoid blocking other teammates.

## Commit Guidelines

A commit is a message to your team and your future self.

Keep the following guidelines in mind when writing a commit message:

- Keep commit messages clear and concise.
- By reading the commit message, the reviewer should be able to understand what the changes do.
- Commits should be small, atomic and self-contained.
- Do not commit multiple unrelated changes in the same commit.
- Start with a verb in the present tense (ie: "add X to Y" or "replace X for Y").

Use [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) to help you create clear and concise commits.

## Pull Request Guidelines

Pull Requests are a communication and review tool that achieve the following goals:

1. Providing visibility of your work.
2. Getting feedback from the team.
3. Challenging the implementation and suggesting improvements.
4. Enforcing code quality and best practices.
5. Detecting and fixing possible bugs before they reach production.

> The reviewer is not responsible for manually testing your code.

Keep the following guidelines in mind when creating a PR:

- PRs should be small, atomic and self-contained.
- Do not create a PR with multiple unrelated changes.
- The PR title should be clear and concise.
- The PR description should contain a summary of the changes and a link to the Jira ticket if applicable.

> Small PRs are easier to review and merge.
