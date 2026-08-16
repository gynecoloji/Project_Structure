---
description: First-run setup — interview the user and fill in the starter Markdown docs of a freshly scaffolded project (metadata, sample sheet, data sources, tools, overview).
---

You are helping set up a **newly scaffolded** bioinformatics project for the first
time. The folders and starter files already exist, but the Markdown files still
contain example rows and placeholders (`<your name>`, `_summarize the key result_`,
example table rows, `name: bioinfo-project`, …). Your job is to **interview the user
and fill in those blanks** — one file at a time, non-destructively.

Follow the project-code + numbered-analysis conventions in `CLAUDE.md`. Do **not**
create folders, run analyses, or invent data — only fill in documentation from what
the user tells you.

## How to run this

1. **Detect the project(s).** List `01-documentation/Metadata_*.md` and the
   `04-analysis/Analysis_*/` folders to see which project code(s) exist. If more
   than one, confirm which to set up (or do each in turn).

2. **Fill these NOW — go file by file, in order.** For each, show the current
   placeholder, ask only the questions needed, then write the file. Confirm before
   overwriting anything the user has already edited.

   1. `01-documentation/Metadata_<code>.md` — expand the one-line description into a
      short paragraph: organism, assay, conditions, goal.
   2. `01-documentation/sample_sheet.tsv` — ask for the samples (id, condition,
      replicate, file path); replace the example rows.
   3. `01-documentation/data_sources.md` — ask what external data is used (genome,
      GTF, motif DBs, public datasets) with URL, version, date accessed; replace examples.
   4. `01-documentation/tools_versions.md` **and** `01-documentation/environment.yml`
      — ask which tools/versions they'll use (offer `conda list` as a shortcut);
      keep the two in sync and rename the env `name:` to something project-specific.
   5. `01-documentation/experiment_log.md` — add the first dated entry
      ("project initialized", who, what); replace the example rows.
   6. `04-analysis/Analysis_<code>/overview.md` — ask the objective, a one-line data
      summary, and the planned analyses; fill the objective and the analyses table.

3. **Leave these for LATER** — tell the user they fill in as work happens (the
   `doc-writer` agent and `/sync-docs` handle them automatically):
   - `02-scripts/Script_<code>/script_summary.md` (when scripts exist)
   - `03-data/Data_<code>/Processed/README.md` (when processed data exists)
   - `04-analysis/.../summary.md` + `params.json` (when a run happens)
   - `05-reports/Analysis_<code>/report_summary.md` (when there are results)

4. **Finish** with a short checklist of what you filled in and what's still pending.

## Rules
- One file at a time; ask before overwriting user edits; preserve anything already filled.
- Markdown with real tables; relative paths; ISO dates (`YYYY-MM-DD`).
- Keep everything under the correct project `<code>`.
- If the user doesn't know a value yet, leave a clear `TODO:` marker rather than guessing.
