---
description: Turn a multi-step plan into a sequence of atomic commits.
---

# Atomic commits for phased work

- Decompose a plan into the smallest changes that each stand on their own:
  one logical change per commit, with a clear before and after.
- Every commit should build, lint, and pass tests on its own. Don't leave the
  tree broken "until the next commit."
- Don't mix unrelated changes (a refactor, a feature, and a formatting sweep)
  in one commit. Separate mechanical changes (rename, reformat) from
  behavioural ones so review and revert stay clean.
- Sequence so each commit depends only on earlier ones: scaffolding and
  refactors first, then the behaviour change, then docs.
- Prefer pairing a behaviour change with its test in the same commit (see the
  testing-and-validation rule).
- Commit at phase boundaries rather than in one drop at the end -- but still
  only when the user has asked you to commit (see the git-commits rule).
