# Hints for cc-008: Prompt Architect

## Hint 1

Good prompts have structure. Three patterns to try: (1) Ask Claude to explore
before acting — understand the code first. (2) Give Claude something to verify
against — like writing tests before implementing. (3) Break complex tasks into
numbered steps so Claude stays focused. Each pattern has a deliverable file
you need to create.

## Hint 2

For exploration: "Read through this project and summarize the API structure in
exploration.md — describe the handlers, types, and what each endpoint does."

For tests-first: "Write tests in src/tests/handlers.test.ts that verify input
validation for createUser, then add validation logic to src/api/handlers.ts."

For step-by-step: "Create plan.md with numbered steps: 1. What validation is
missing? 2. What rules are needed? 3. Implement the validation."

## Hint 3

Three prompts to complete this exercise:

1. "Explore the codebase and write a summary of the API structure to
   exploration.md. Describe the handlers, types, and any issues you notice."

2. "Write tests in src/tests/handlers.test.ts that verify createUser rejects
   invalid input (missing name, bad email, negative age). Then add a
   validateCreateUserInput function to src/api/handlers.ts and use it in
   createUser."

3. "Create plan.md with these steps: 1. Identify what input validation is
   missing in createUser. 2. List the validation rules needed (name required,
   valid email, age > 0). 3. Implement the validation function and integrate
   it into the handler."
