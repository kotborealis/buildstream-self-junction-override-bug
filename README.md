# bst-override-repro

Minimal BuildStream project that reproduces an option-scope bug in a self-junction override flow.

## What bug this reproduces

When resolving `self_junction.bst:thing.bst`, BuildStream evaluates conditions from `thing.bst`
before the expected override behavior takes effect in this self-junction setup.
While evaluating conditions, the options are not loaded yet, which causes errors.

Observed failure:

```text
self_junction.bst:thing.bst [line 4 column 4]: Failed to evaluate expression (some_option == "x"): 'some_option' is undefined
```

Issue created from this repro:

- https://github.com/apache/buildstream/issues/2118

## Reproduction command

Run from project root:

```sh
/home/evgeny/projects/build-platform/.venv/bin/bst show self_junction.bst:thing.bst
```

Expected result: command fails with `'some_option' is undefined`.

## Project structure

```text
.
├── project.conf
├── elements/
│   ├── self_junction.bst
│   ├── subproject.bst
│   ├── thing.bst
│   └── thing_override.bst
└── subproject/
    ├── project.conf
    ├── elements/
    │   └── .keep
    └── include/
        └── extra.yml
```

## Roles of key files

- `project.conf`
  - Defines top-level option `some_option`.
  - Includes `subproject.bst:include/extra.yml`.
  - Marks `self_junction.bst` and `subproject.bst` as internal junctions.
- `elements/self_junction.bst`
  - Self-junction that re-imports this project (`elements`, `subproject`, `project.conf`).
  - Forwards `some_option`.
  - Overrides `thing.bst` with `thing_override.bst`.
- `elements/thing.bst`
  - Contains condition `some_option == "x"`.
- `elements/thing_override.bst`
  - Also contains condition `some_option == "x"`.
- `elements/subproject.bst` + `subproject/`
  - Minimal nested junction payload used by top-level include path.
