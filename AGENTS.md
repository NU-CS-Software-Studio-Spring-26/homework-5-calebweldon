## Stack
- Rails 8 sample todo app
- Database: SQLite
- Views: ERB + Hotwire (Turbo/Stimulus) with importmap; JSON views via Jbuilder
- Tests: Minitest (+ Capybara/Selenium for system tests)
- Jobs: Active Job with Solid Queue (`solid_queue`, `config/queue.yml`)

## Commands
- Setup: `bin/setup`
- Run app locally: `bin/dev`
- Run tests: `bin/rails test`
- Lint: `bin/rubocop`

## Conventions
- Standard Rails naming: singular models, plural controllers/routes; keep code in the usual folders
- Authorization: not implemented yet; if added, keep it in controller callbacks / app-level policy code (not in views)
- Controllers: use `before_action` + `params.expect(...)`; respond with `respond_to` (HTML + JSON; Turbo is fine for HTML)
- Partials: keep resource partials in `app/views/<resource>/`; put truly shared partials in `app/views/shared/`

## Don'ts
- No new gems without approval
- No `skip_before_action :verify_authenticity_token`
- No inline JavaScript in ERB (instead, place in `app/javascript`)