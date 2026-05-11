# FITEAT — Senior Architecture Review

**Reviewer role:** Senior Staff Mobile Architect
**Date:** 2026-05-11
**Scope:** Pre-MVP review of Flutter app + local Supabase backend
**Mode:** Brutally honest. No marketing tone.

---

## 0. TL;DR

You are roughly **40% to a real MVP**. The Flutter scaffolding is competent for someone at your stage, but the **backend has critical gaps that make several PRD features physically impossible today** (auto-calorie, likes, comments, follows, favorites, badges — none of the tables exist). You also have two stacks fighting each other: **Firebase pods on iOS** + **Supabase in Dart**. Pick one. The migrations you've written are actually high-quality (RLS, revoked counter columns, trigger discipline) — that's the strongest part of the project, don't lose that quality as you fill the gaps.

If you do nothing else in the next 7 days: finish the missing migrations, add the nutrition columns, and decide on Firebase.

---

## 1. System Overview (current vs. target)

**Current:**

```
[Flutter app] ──supabase_flutter──▶ [Local Supabase via Docker]
       │                                  ├─ Auth (anon + google + email)
       │                                  ├─ Postgres (profiles, recipes, ingredients,
       │                                  │   recipe_ingredients, recipe_media,
       │                                  │   recipe_steps, recipe_categories, categories)
       │                                  └─ Storage (buckets configured)
       │
       └──(unused?)──▶ [Firebase iOS pods: Auth + Firestore + AppCheck]
       └──(unused?)──▶ [dio]
       └──(unused?)──▶ [provider]
```

**Target for MVP launch:**

```
[Flutter app] ──supabase_flutter──▶ [Hosted Supabase project]
                                      ├─ Auth
                                      ├─ Postgres
                                      │   + likes, follows, comments, favorites,
                                      │   + badges, user_badges, ingredient_suggestions,
                                      │   + nutrition columns + compute_recipe_nutrition()
                                      ├─ Storage (cdn-fronted)
                                      └─ Edge Functions (rate limiting, badge awards,
                                                         featured-of-the-day cron)
```

You do not need a separate backend server. Supabase + Edge Functions covers MVP.

---

## 2. Priority Roadmap

### MVP (ship in 4–6 weeks if you focus)
1. Auth (anon + google + email) — mostly done.
2. Recipe creation flow end-to-end (title, steps, ingredients, categories, ≥1 image).
3. Recipe detail.
4. Home feed with keyset pagination.
5. Search (recipes by title + users by username).
6. Like, save, follow, flat comments.
7. Profile + 3-col grid.
8. Auto-calorie (read-only — needs nutrition columns).
9. Theme + logout.

### V1 (next 6 weeks after MVP)
- Email verification + password reset.
- Account deletion.
- Featured-of-the-day (admin RPC + cron).
- Comment replies (depth 1).
- Badge system + Lottie unlock.
- Report content.
- Ingredient suggestion approval queue.
- Multi-language UI.
- Hosted Supabase migration off Docker.

### V2 (later)
- Custom favorite lists.
- Threaded comments (multi-level).
- Personalized recommendations.
- AI assistant (revive `ai_asistan_page` if it earns its place).
- Recipe versioning.
- Leaderboards.

### Should be removed today
- `ai_asistan_page/` folder — not in PRD, not in MVP. Either move under `feature_flagged/` or delete.
- `provider` package — `flutter_bloc` is the chosen stack.
- `dio` — if no non-Supabase HTTP exists, delete.
- Firebase iOS pods + `firebase.json` — unless FCM is coming, this is technical debt.

---

## 3. Database Review

### What's good
- RLS enabled on every table you've written.
- Counter columns (`like_count`, etc.) are `REVOKE`d from `anon`/`authenticated` — trigger-only. This is **the** correct pattern and most juniors miss it.
- `slug` constraint with regex, `username` constraint with citext + regex.
- Use of `gen_random_uuid()`, `pg_trgm` index, helper functions `is_recipe_visible` / `is_recipe_owner` — clean.
- `set_updated_at()` trigger pattern reused — good.
- `recipes.status` enum + check that published rows have `published_at` — solid.

### What's missing (blocking MVP)
1. **`recipe_likes`** — `(user_id, recipe_id)` PK, RLS insert-own, trigger to update `recipes.like_count`.
2. **`recipe_favorites`** — same shape as likes.
3. **`follows`** — `(follower_id, followee_id)` PK, RLS insert-own, CHECK `follower_id <> followee_id`, triggers updating both `profiles.followers_count` and `profiles.following_count`.
4. **`comments`** — id, recipe_id, author_id, parent_id (nullable, self-FK), body, created_at, soft_delete flag. CHECK on depth (use a recursive CTE or store `depth` column updated on insert via trigger; cap at 1 for MVP). Counter trigger on `recipes.comment_count`.
5. **`ingredient_suggestions`** — id, suggested_name, suggested_unit, submitter_id, status enum, reviewer_id, decided_at. RLS: insert by authed, select own + admin, update only admin.
6. **`badges`** — catalog table (key, title, description, icon_url). Static seed.
7. **`user_badges`** — `(user_id, badge_key)` PK, awarded_at. Idempotent inserts via `on conflict do nothing`. Trigger-awarded based on conditions.
8. **`recipe_views`** OR a debounced RPC `record_view(recipe_id)`. The latter is cheaper if you don't need analytics.
9. **Nutrition on `ingredients`:** `kcal_per_100g numeric`, `protein_g numeric`, `carbs_g numeric`, `fat_g numeric` (all nullable, with CHECK `>= 0`).
10. **`compute_recipe_nutrition(recipe_id uuid)`** — Postgres function: sums `(quantity * unit_conversion_factor * kcal_per_100g / 100)` over ingredients. Trigger calls it on `recipe_ingredients` insert/update/delete to update a `recipes.kcal_total` column. **Important:** unit conversion is the hard part. For MVP, define a normalization to grams via a `unit` enum and a static conversion table.

### What's wrong / risky
- **`recipe_steps`** as a separate table is correct, but make sure you have a `unique(recipe_id, sort_order)` constraint and an index on `(recipe_id, sort_order)`. Otherwise re-ordering hits N+1 hell.
- **No `tsvector` on `recipes.title`.** Today `ILIKE` is fine because the table is empty. At 50k rows you'll regret it. Add a generated tsvector column + GIN index now.
- **`ingredients.name` is `unique`** but case-sensitive. "Soğan" vs "soğan" → two rows. Either store lowercase in a generated column or switch to `citext`. (You did this for `username`. Be consistent.)
- **No `recipe_views` denormalization story.** `view_count` exists but nothing updates it. Decide and write the function.
- **Comments depth enforcement is missing.** If you leave `parent_id` unbounded, V1 will accidentally allow infinite nesting. Add a `depth` column with CHECK ≤ 1 for MVP.
- **No moderation columns.** `profiles.is_banned`, `recipes.is_hidden`, `comments.is_hidden`. Add now while tables are small; backfilling is annoying later.

---

## 4. Security Review

### Good
- RLS-first, counter columns locked, helper functions are `security invoker` (correct default).
- Anonymous users can't write — current policies enforce this through `auth.uid()` checks.

### Gaps
1. **No rate limiting.** A motivated user can spam likes (just toggle 1000x), comments, follows. Mitigate with:
   - Edge function in front of comments + new-recipe creation with a `(user_id, action, window)` table.
   - Or pg_cron + a `rate_limit_buckets` table keyed by `user_id + action`.
2. **No admin role.** Approving `ingredient_suggestions` requires either a `claims` JWT bit, an `admins` table, or a Postgres role. Pick **one** and commit. Recommendation: an `admins(user_id)` table + a `security definer` function `approve_ingredient_suggestion(id)` that checks `auth.uid() in (select user_id from admins)`.
3. **Service role key safety.** Confirm `flutter_dotenv` only ever loads the anon key on-device. The service role key must never appear in any client bundle, ever.
4. **Anonymous → authed identity link.** Today there's no plan for what happens to anonymous users' recently-viewed list when they create an account. Decide and test `linkIdentity`.
5. **Storage bucket policies.** I see `20260505083737_storage_buckets.sql` but haven't audited it. Confirm:
   - Avatars: public read, owner-only write.
   - Recipe media: public read for published recipes, owner-only write, NO public list.
   - Max file size policy in bucket config.

---

## 5. Performance Review

### What's right
- `recipes_feed_idx` is a partial index on `(published_at desc, author_id) where status = 'published'`. This is exactly what you want for the feed.
- Denormalized counter columns.

### Junior-mistake watch list
- **Don't use `range()` for offset pagination** in the Flutter feed. Use `lt('published_at', cursor)` + `order('published_at', ascending: false).limit(20)`. Or compose a tuple cursor `(published_at, id)`.
- **Don't `count(*)` for follower counts.** Use the trigger-maintained column.
- **Don't compute calories in Dart.** Server function only. If the user changes an ingredient quantity, re-trigger server-side.
- **Don't fetch all comments at once.** Cursor on `(created_at, id)`. "Load more" hits the next page.
- **Don't bind a `StreamBuilder` to the entire recipes table.** It will resync everything on every change. Realtime subscribe to a single recipe id when on detail screen, nothing else.
- **Image pipeline:** compress to ≤ 1 MB before upload, generate a thumbnail (~ 400px wide) server-side via an Edge Function or store two variants client-side.

---

## 6. Flutter Architecture Review

### Folder structure — verdict: 7/10
Feature-first is correct. Inside each feature you have `model / service / state / viewmodel / view / widget`, which is fine. But:

- Inconsistencies (`ai_asistan_page`, `intites`, `services` vs `service`, missing `state/` in some features) signal lack of a project lint or template. Add a tiny script under `tools/check_feature_layout.dart` that fails CI if a feature is missing the canonical folders.
- `interactions/` is suspicious. It has only `model` and `service`. Either it's a shared library (move under `core/data/`) or it should be per-feature. Don't leave it dangling.
- `core/entities/` and `core/components/` — components belong in `core/widgets/`. Rename for clarity.

### Cubit boundaries — verdict: needs structure
Suggested split:

| Cubit | State holds | Lives in |
|---|---|---|
| `AuthCubit` | anon/authed user + profile snapshot | `core/cubits/auth_cubit.dart` |
| `ThemeCubit` | brightness | `core/cubits/theme_cubit.dart` |
| `HomeFeedCubit` | feed pages + cursor + isLoadingMore | `features/home_page/viewmodel/` |
| `RecipeDetailCubit` | one recipe + ingredients + steps + comments first page | `features/recipe_detail/viewmodel/` |
| `RecipeDetailCommentsCubit` | comments pagination only (separate from detail) | same feature |
| `CreateRecipeCubit` | form state + submission status | `features/create_recipe_page/viewmodel/` |
| `ProfileCubit` (own) and `OtherProfileCubit` | different scopes — own profile listens to AuthCubit, others fetch by id | `features/account_page/viewmodel/` |
| `SearchCubit` | query, results, debounce | `features/...search/viewmodel/` |
| `FavoritesCubit` | saved list | `features/favorite_page/viewmodel/` |
| `IngredientPickerCubit` | autocomplete for create-recipe flow | `features/ingredient/viewmodel/` |

Rules:
- One Cubit per screen by default. Big screens may justify two (detail + comments).
- Cubits never call Supabase directly — only repositories.
- States are `Equatable` sealed classes with `Initial / Loading / Success(data) / Failure(failure)`.
- A `Failure` sealed class lives in `core/error/`. No raw `Exception` reaches a Cubit.

### Repository pattern — verdict: rename mentally, behavior matters
You've named them `service/`. That's fine. The contract that matters:

```dart
abstract class RecipeRepository {
  Future<Result<List<Recipe>, Failure>> fetchFeed({RecipeCursor? cursor, int limit = 20});
  Future<Result<RecipeDetail, Failure>> fetchById(String id);
  Future<Result<Recipe, Failure>> create(CreateRecipeInput input);
  Future<Result<void, Failure>> toggleLike(String recipeId);
  // ...
}
```

- `Result<T, F>` = sealed class (`Ok(T)` / `Err(F)`).
- Implementation lives in `service/recipe_supabase_service.dart`.
- Bind via GetIt in `product_container.dart`.

This makes the Cubit trivially testable with a fake repo.

### DI with GetIt — verdict: keep simple
`product_container.dart` should expose `ProductContainer.setup()` called from `main()` before `runApp`. Order:
1. Register `SupabaseClient` as a singleton.
2. Register repositories as lazy singletons depending on `SupabaseClient`.
3. Cubits are NOT registered in GetIt — instantiate them per route via `BlocProvider(create: (_) => HomeFeedCubit(getIt()))`. This avoids state leaking across navigations.

---

## 7. Local Supabase / Docker Deployment Strategy

You're running Supabase via the CLI in Docker. That is the right dev setup. Here's the deployment plan:

| Phase | What runs where |
|---|---|
| **Dev (now)** | Local Supabase in Docker on your machine. `.env` points to `http://127.0.0.1:54321`. All migrations applied locally first. |
| **Pre-launch staging** | A free-tier hosted Supabase project. CI applies migrations on push. Build flavor "staging" points to it. |
| **Production** | Paid Supabase project. Migrations applied via `supabase db push` from CI on tagged release only. RLS audit before going live. |

Things that **must stay local during dev**:
- Auth signups (don't pollute production with test accounts).
- Storage uploads (don't pollute production buckets).
- Anything calling `compute_recipe_nutrition` while you iterate.

Things to **move to hosted Supabase before public testing**:
- Push notifications via Edge Functions (if you decide to use Supabase rather than FCM).
- Anything using `pg_cron` (e.g. featured-of-the-day) — local cron is unreliable.
- Storage CDN — local has no CDN, so feed perf can't be measured.

Migration discipline (do this now, not later):
- Every schema change = a new SQL file under `supabase/migrations/`.
- Never edit a past migration. Add a new one to alter.
- `supabase db reset` should rebuild a working DB from zero with seed data. Keep that property green at all times.
- Add a `supabase/seed.sql` that seeds 5 fake recipes + 3 fake users for fast UI iteration.

---

## 8. Caching, Offline, Media — Concrete Plan

### Caching
- **Image cache:** `cached_network_image` is in deps. Use it for every remote image.
- **Recipe DTO cache:** in-memory LRU (max ~200 entries) inside `RecipeRepository`. Invalidate on like/save/comment locally for optimistic UI.
- **Profile cache:** same pattern.
- **Persistence:** `shared_preferences` for user prefs + last cursor of feed. Don't go to SQLite for MVP.

### Offline
- Read-only offline: cache last home feed page in `shared_preferences` (a serialized JSON of ~20 recipes). On launch with no network, show that. No write queue.
- Write offline (queue create-recipe while offline) is **V2**. Drop from MVP.

### Media upload
1. User picks image/video via `image_picker`.
2. Client compresses with `flutter_image_compress` (target ≤ 1 MB, jpeg quality 80).
3. Upload to `recipe-media` bucket at path `user_id/recipe_id/{uuid}.jpg`.
4. Insert row in `recipe_media` with the public URL + a derived thumbnail URL (or trigger an Edge Function to make a thumb).
5. Failure: retry once, then surface error.

Don't upload from `Future<void>` in the Cubit's submit handler directly — use a `MediaUploadService` and stream progress back so the UI can show a real progress bar.

---

## 9. Moderation Plan (must exist before public)

- `profiles.is_banned boolean default false` — RLS denies all writes when true.
- `recipes.is_hidden boolean default false` — feed excludes hidden recipes.
- `comments.is_hidden boolean default false` — detail page replaces body with "[hidden]".
- **Report flow** (V1): `reports(reporter_id, target_type, target_id, reason, status)` — admins triage.
- Auto-hide on N reports (e.g. 5) via trigger. Manual unhide by admin.

---

## 10. Badge System Architecture

Approach: declarative + idempotent.

1. Static `badges` table: `(key, title, description, icon_url)`. Seed once.
2. `user_badges (user_id, badge_key, awarded_at)`, PK on both, `on conflict do nothing`.
3. For each badge, write a Postgres function that checks the rule and inserts. Examples:
   - `award_first_recipe(user_id)` — call from a trigger on `recipes` insert when `status='published'` and the user has no prior published recipe.
   - `award_world_cuisine_explorer(user_id)` — trigger on `recipe_categories` insert; count distinct cuisine categories for user; award at threshold.
4. Wrap badge inserts in `security definer` functions so RLS doesn't get in the way.
5. **Don't compute badges in Dart.** Server-side only.

UI: `BadgeService.subscribeToUserBadges(userId)` listens for inserts. On a new row, show Lottie animation.

---

## 11. Search Architecture

MVP: server-side with Postgres.

- `recipes`: add `search_doc tsvector` generated column from `title || ' ' || coalesce(description,'')`. GIN index.
- `profiles`: already has `username_trgm_idx`. Add `display_name` trigram too.
- Single search endpoint = a Postgres function `search_all(q text)` returning a UNION of recipes + users (with a type tag).

V2: Algolia or Typesense. Don't pre-optimize.

---

## 12. Critical Risks (in order)

1. **You can't ship MVP today because the tables don't exist.** Likes, follows, comments, favorites, badges — none of them. (Highest priority risk.)
2. **Calorie compute is impossible without nutrition columns.** PRD lists this as a hero feature.
3. **Firebase + Supabase parallel stacks.** Build error, library conflicts, App Store reviewer confusion, and wasted IPA size. Resolve before any production build.
4. **No rate limiting + no moderation columns.** First viral moment = first spam wave = first PR disaster.
5. **Offset pagination temptation.** If you write `range(0, 19)` instead of a cursor, replace it before the table grows.
6. **Service role key leakage.** Confirm `.env` only ships the anon key.
7. **No CI / no migrations gate.** Today, a migration with broken RLS can be added without anyone noticing. Add CI that runs `supabase db reset` + a smoke RLS test.
8. **Inconsistent feature layout** (`intites`, `ai_asistan_page`, etc.). Cosmetic now, painful at 30+ features.
9. **No comment depth cap.** Future-you will allow 17-level threads.
10. **No retention/analytics plan.** Even basic event logging (recipe_view, sign_up, recipe_create) needs to start day-one. PostHog or Supabase + custom table.

---

## 13. Required Endings (per CLAUDE.md §1)

1. **Current architecture score:** **6/10** — solid scaffolding and migration discipline, but multiple foundational tables missing and dependency hygiene issues.
2. **MVP readiness score:** **4/10** — feed/profile UI structure exists, but social features have no backend.
3. **Scalability score:** **7/10** — the choices you've made (RLS, partial indexes, denormalized counters, keyset-friendly schema) scale well. The risk is failing to follow these patterns as you add the missing tables.
4. **Biggest technical risk (one sentence):** Six MVP features depend on tables that don't exist yet, and the auto-calorie hero feature additionally requires nutrition columns that haven't been added.
5. **Next 3 highest-priority tasks:**
   1. Write migrations for `recipe_likes`, `recipe_favorites`, `follows`, `comments`, `ingredient_suggestions`, `badges`, `user_badges` — each with RLS, counter triggers, and depth/integrity checks.
   2. Add nutrition columns to `ingredients` + write `compute_recipe_nutrition()` function + trigger; backfill seed data with kcal/100g.
   3. Resolve Firebase-vs-Supabase: either delete `firebase.json` and the iOS pods, or document the FCM-only role in a comment at the top of `pubspec.yaml`.
