## Part 1
- [.cursorignore](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-calebweldon/blob/hw5/.cursorignore)

## Part 2
- [AGENTS.md](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-calebweldon/blob/hw5/AGENTS.md)
- [.cursor/rules/rails-conventions.mdc](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-calebweldon/blob/hw5/.cursor/rules/rails-conventions.mdc)
- [.cursor/rules/security.mdc](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-calebweldon/blob/hw5/.cursor/rules/security.mdc)

## Part 3 (ASK)
- **Prompt:** Where in this codebase is "where the todos index is filtered" currently implemented? Cite the
exact files and line numbers. Do not propose changes.
- app/views/todos/index.html.erb [lines 5-7] (todos index is not filtered beyond loading every todo from the DB)
- app/controllers/todos_controller.rb [lines 6-13] (no filtering)
- app/views/todos/index.json.jbuilder [line 1] (no filtering)
- app/models/todo.rb [no lines] (no filtering)
- I confirmed that the citations are real

## PART 3 (PLAN)
- **Prompt:** I want to change where the todos index is filtered so that the index supports a filter query param with values all (default), overdue (todos with a due date in the past), and upcoming (todos due within the next 7 days). Propose a plan as a numbered list of changes, including files to edit, new tests to add, and any migration. Do not write code.

- **Plan from agent:**
  1. **Add model scopes in `app/models/todo.rb`**
     - Add two scopes that only consider todos with a non-null `due_date`:
       - `overdue`: `due_date` is before the current time
       - `upcoming`: `due_date` is between now and 7 days from now (inclusive of that window)
     - Todos with no `due_date` should be excluded from both filtered scopes and only appear under `all`.
     - Keep query logic in the model so it is reusable and testable.
  2. **Apply the filter in `app/controllers/todos_controller.rb`**
     - Replace `@todos = Todo.all` in `#index` with logic that reads `params[:filter]`.
     - Supported values:
       - missing, blank, or `"all"` → `Todo.all`
       - `"overdue"` → `Todo.overdue`
       - `"upcoming"` → `Todo.upcoming`
     - Unknown values should fall back to `Todo.all`.
     - Assign `@todos` once in the controller so HTML and JSON index responses stay in sync. Do not duplicate filtering in `app/views/todos/index.html.erb` or `app/views/todos/index.json.jbuilder`.
  3. **Add filter controls to `app/views/todos/index.html.erb`**
     - Add simple links or a GET form above the todo list for `All`, `Overdue`, and `Upcoming`.
     - Each control should hit `/todos?filter=...` using normal Rails URL helpers.
     - No new JavaScript or Stimulus controller is required.
  4. **Update fixtures in `test/fixtures/todos.yml`**
     - Give fixtures distinct `due_date` values so tests can distinguish:
       - one overdue todo
       - one upcoming todo (within 7 days)
       - one with no due date
       - optionally one due more than 7 days out (should not appear in `upcoming`)
  5. **Add model tests in `test/models/todo_test.rb`**
     - Test `Todo.overdue` returns only past-dated todos with a due date.
     - Test `Todo.upcoming` returns only todos due within the next 7 days.
     - Test todos without a `due_date` are excluded from both scopes.
  6. **Add controller tests in `test/controllers/todos_controller_test.rb`**
     - Keep the existing `"should get index"` test for the default unfiltered case.
     - Add tests for:
       - `GET /todos?filter=overdue` returns success and only overdue fixture(s)
       - `GET /todos?filter=upcoming` returns success and only upcoming fixture(s)
       - `GET /todos?filter=all` returns all todos
       - invalid filter value falls back to all todos
     - Assert on assigned records or response body content using fixture descriptions.
     - Optionally add one JSON index test to confirm filtered `@todos` is serialized the same way.
  7. **Optional system test in `test/system/todos_test.rb`**
     - Only if filter links are added in step 3: visit index, click `Overdue`, and assert only the expected todo appears.
     - Not required if controller/model tests are thorough, but useful for the new UI controls.
  **Migration:** None. The `due_date` column already exists via `db/migrate/20260519180933_add_due_date_to_todo.rb`.
  **Files to edit:**
  - `app/models/todo.rb`
  - `app/controllers/todos_controller.rb`
  - `app/views/todos/index.html.erb`
  - `test/fixtures/todos.yml`
  - `test/models/todo_test.rb`
  - `test/controllers/todos_controller_test.rb`
 
- **My edits:**
  - Dropped the system test (step 7). model + controller tests cover enough for now.
  - Choose plain filter links in the view instead of a GET form. Three links (All / Overdue / Upcoming) with `?filter=...` is all we need
  - Freeze time in tests with `travel_to` so overdue/upcoming don't break depending on when you run them.

## PART 3 (AGENT)

- **Prompt:** Implement only step 1 from my plan: add `overdue` and `upcoming` scopes to `app/models/todo.rb`. Overdue means `due_date` is in the past; upcoming means `due_date` is within the next 7 days. Exclude todos with no `due_date` from both scopes. Do not change the controller, views, or tests yet.

- **Commit:** [d503a6f](https://github.com/NU-CS-Software-Studio-Spring-26/homework-5-calebweldon/commit/d503a6f)