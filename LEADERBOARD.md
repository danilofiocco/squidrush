# Leaderboard

Scores are shared by everyone through the `squid_scores` table in Supabase (the same project as
the balloon game). `index.html` reads the top 100 when the game loads and saves a score when the
player enters a name on the game-over screen (SKIP saves nothing).

The table was created with:

```sql
create table public.squid_scores (
  id bigint generated always as identity primary key,
  name text not null check (char_length(name) between 1 and 12),
  score integer not null check (score between 0 and 100000),
  created_at timestamptz not null default now()
);
alter table public.squid_scores enable row level security;
-- Anyone can read the ranking and add a score; nobody can edit or delete.
create policy "read squid scores" on public.squid_scores for select to anon using (true);
create policy "add a squid score" on public.squid_scores for insert to anon with check (true);
create index squid_scores_rank on public.squid_scores (score desc, id);
```

To clear the ranking (Supabase → SQL Editor): `truncate public.squid_scores restart identity;`
A single bad row can be deleted in the Table Editor.

The publishable key in `index.html` is meant to be public: the policies limit it to reading and
adding. It can't stop someone posting a made-up score; the checks cap the damage.

## How the page and the game talk (view model)

| Property | Direction | Meaning |
|---|---|---|
| `scoreSubmitted` (trigger) | game → page | a name was entered |
| `submittedName`, `submittedScore` | game → page | the name and the shells collected |
| `rankingData` | page → game | the list, best first: one `NAME<tab>SHELLS` line per row |
| `rankHighlight` | page → game | the player's row (1, 2, …), 0 for none |
| `systemLanguage` | page → game | `navigator.language`; "pt…" shows Brazilian Portuguese |
| `viewL/R/T/B` | page → game | the visible part of the artboard, for wide or tall windows |
| `hostKeys`, `hostKeyboard` | page → game | the keyboard (the web runtime doesn't pass keys to the script) |
| `rankingWheel` | page → game | mouse-wheel scrolling of the list |
