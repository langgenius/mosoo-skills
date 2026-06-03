# External Guides

Use these sources to justify or tune the rules in the main skill. Prefer repo-local rules if they are stricter.

## TypeScript Handbook

Source:

- https://www.typescriptlang.org/docs/handbook/advanced-types.html

Useful takeaways:

- Use type aliases to name otherwise awkward types.
- Prefer interfaces for object-shape extension patterns.
- Do not confuse "possible in the type system" with "good API surface."

## TypeScript Compiler Coding Guidelines

Source:

- https://github.com/microsoft/TypeScript/wiki/Coding-guidelines

Useful takeaways:

- Keep type declarations readable and near the top of the file.
- Use `undefined` instead of `null` unless a null contract is required.
- Optimize for maintainability over clever type tricks.

## VS Code Coding Guidelines

Source:

- https://github.com/microsoft/vscode/wiki/Coding-Guidelines

Useful takeaways:

- Name types in PascalCase and keep conventions consistent.
- Keep exports and abstractions intentional.
- Inference from the codebase and guidelines: public-facing code favors named, readable contracts over dense inline type expressions.

## Google TypeScript Style Guide

Source:

- https://google.github.io/styleguide/tsguide.html

Useful takeaways:

- Prefer clarity over novelty.
- Keep nullability and optionality explicit and consistent.
- Avoid patterns that make static analysis or review harder without adding real value.

## typescript-eslint

Source:

- https://typescript-eslint.io/users/configs
- https://typescript-eslint.io/rules/

Useful takeaways:

- Convert style preferences into lint rules where possible.
- Use typed lint rules to prevent unsafe `any`, unsafe member access, and weak promise handling.
- Do not invent a style rule if the repo cannot enforce or review it consistently.
