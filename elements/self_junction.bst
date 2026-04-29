kind: junction

sources:
  - kind: local
    path: elements
    directory: elements

  - kind: local
    path: subproject
    directory: subproject

  - kind: local
    path: project.conf

config:
  options:
    some_option: "%{some_option}"

  overrides:
    thing.bst: thing_override.bst
