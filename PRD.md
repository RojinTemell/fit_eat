# FITEAT — Product Requirements Document (PRD)

> Single source of truth for product features. If something isn't in this doc, it isn't part of the product. Changes go through a dated entry at the bottom.

**Version:** 0.2 (post architecture review)
**Owner:** Rojin
**Last updated:** 2026-05-11

---

## 1. Product Summary

FITEAT is a social recipe platform for sharing healthy, home-cooked food. Differentiators:

1. **Auto-calorie computation** from ingredients (no manual entry).
2. **Gamification** via a badge system (first recipe, world cuisine explorer, chef, etc.).
3. **Anonymous browsing** with friction-free upgrade to a full account when the user wants to interact.

Target user (MVP): Turkish-speaking home cooks aged 18–45, mobile-first.

---

## 2. Tech Stack

See `CLAUDE.md` §2. Locked. Do not propose changes in this PRD.

---

## 3. User Roles

| Role | Can do |
|---|---|
| Anonymous visitor | Browse feed, view recipe detail, search, read comments. **Cannot** like, save, comment, follow, create recipes. |
| Authenticated user | All of the above + like / save / comment / follow / create recipes / earn badges. |
| Moderator (V1+) | Approve `ingredient_suggestions`, ban abusive users, hide content. |
| Service / system | Trigger-driven counter updates, badge awards, nutrition compute. Not exposed to clients. |

---

## 4. Authentication

- **Anonymous mode:** Supabase anonymous sign-in on first launch. Session is real but limited by RLS.
- **Sign-up methods:** Google OAuth, Email + Password.
- **Upgrade path:** anonymous → authenticated must preserve UUID via Supabase `linkIdentity` so any recently-viewed history isn't lost.
- **Logout:** clears Supabase session + local cached identity.
- **Account deletion:** V1. Must cascade via FK on `auth.users.id` → `profiles.id`.

---

## 5. Feature Catalog (with priority)

Legend: **M0** = MVP must-have · **M1** = MVP nice-to-have · **V1** = next release · **V2** = later · **CUT** = remove

### 5.1 Auth & Profile
| # | Feature | Priority | Notes |
|---|---|---|---|
| 1 | Anonymous sign-in on launch | M0 | |
| 2 | Google sign-in | M0 | |
| 3 | Email + password | M0 | |
| 4 | Profile creation (auto via trigger) | M0 | Already implemented in DB. |
| 5 | Edit profile (display_name, bio, avatar) | M0 | Restricted columns via grant. |
| 6 | Followers / following counts | M0 | Denormalized + trigger. |
| 7 | Account deletion | V1 | |
| 8 | Email verification flow | V1 | |
| 9 | Reset password | V1 | |

### 5.2 Recipes
| # | Feature | Priority | Notes |
|---|---|---|---|
| 10 | Create recipe (title, steps, ingredients, categories, cover image) | M0 | |
| 11 | Upload images (≥1 required) | M0 | Compressed client-side, original + thumbnail in Storage. |
| 12 | Upload short video | M1 | Defer if Storage costs are a concern. |
| 13 | Ingredient autocomplete from `ingredients` table | M0 | |
| 14 | Submit new ingredient (approval queue) | V1 | Out of MVP — use seeded list. |
| 15 | Auto-calorie compute | M0 | **Requires** kcal columns on `ingredients` + RPC. Currently impossible — DB gap. |
| 16 | Difficulty (easy/medium/hard) | M0 | Enum in DB. |
| 17 | Servings + cook time | M0 | |
| 18 | Categories (many-to-many) | M0 | |
| 19 | Recipe versioning / edit history | V2 | |
| 20 | Draft / published / archived statuses | M0 | Already in DB. |

### 5.3 Social
| # | Feature | Priority | Notes |
|---|---|---|---|
| 21 | Like recipe | M0 | |
| 22 | Save to favorites (single set) | M0 | |
| 23 | Custom favorite lists | V2 | Don't ship in MVP. |
| 24 | Follow user | M0 | |
| 25 | Comments (flat) | M0 | |
| 26 | Comment replies (one level) | M1 | Cap at depth 1 for MVP. |
| 27 | Threaded comments (multi-level) | V2 | |
| 28 | Share recipe (OS share sheet + deep link) | M0 | |
| 29 | Report content | V1 | |

### 5.4 Discovery
| # | Feature | Priority | Notes |
|---|---|---|---|
| 30 | Home feed (infinite scroll, keyset pagination) | M0 | |
| 31 | Featured recipe of the day | M1 | Manual pick via admin RPC. |
| 32 | Category browse | M0 | |
| 33 | Search (recipes + users) | M0 | `pg_trgm` GIN on title + username. |
| 34 | Recently viewed | M0 | Client-side list (last 20) + optional server table. |
| 35 | Personalized recommendations | V2 | |

### 5.5 Gamification
| # | Feature | Priority | Notes |
|---|---|---|---|
| 36 | Badge system (first recipe, chef, beginner, world cuisine) | M1 | Server-side, idempotent, trigger-awarded. |
| 37 | Badge unlock animation | M1 | Lottie already in deps. |
| 38 | Leaderboards | V2 | |

### 5.6 Settings
| # | Feature | Priority | Notes |
|---|---|---|---|
| 39 | Theme switch (dark/light) | M0 | |
| 40 | Language switch | M1 | Scaffold only — ship Turkish first. |
| 41 | Logout | M0 | |
| 42 | Notification preferences | V1 | |

### 5.7 Cut from MVP entirely
| # | Feature | Reason to cut |
|---|---|---|
| 43 | AI assistant page (`ai_asistan_page`) | Not in original PRD. Defer to V2 or remove the folder. |
| 44 | Stories / reels | Scope explosion. |
| 45 | Real-time presence / typing | Premature. |
| 46 | Recipe rating (stars) | Likes already serve as the signal. Don't add a second axis pre-MVP. |
| 47 | In-app chat / DMs | Massive moderation surface. V2 at earliest. |

---

## 6. Screens (MVP)

1. **Splash** — bootstraps Supabase, decides anon vs authed route.
2. **Auth** — sign-in / sign-up.
3. **Home feed** — featured + infinite scroll.
4. **Search** — recipes + users.
5. **Recipe detail** — carousel, ingredients, steps, comments.
6. **Create recipe** — multi-step form.
7. **Profile** (own + other) — 3-col grid, followers/following, badges.
8. **Favorites** — single saved list.
9. **Settings**.

Comment full-page view: separate route (`/recipes/:id/comments`), not a sheet, for MVP.

---

## 7. Non-functional Requirements

- **P95 home feed load:** < 800 ms over 4G.
- **Image upload:** auto-compress to ≤ 1 MB before transit.
- **Offline read:** cached feed page renders without network.
- **Crash-free sessions:** target ≥ 99.5% before public launch.
- **Cold start to first frame:** < 2.5 s on mid-range Android.

---

## 8. Out of Scope

See §5.7 plus: monetization, ads, paid recipes, marketplace, ordering, grocery delivery, nutritionist consult.

---

## 9. Change Log

- **2026-05-11 v0.2** — Initial structured PRD derived from informal spec. Added priority tiers, cut list, nutrition columns gap, MVP screens.
