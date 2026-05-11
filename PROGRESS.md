# PROGRESS.md — Session Log

> **Update this at the end of every Claude Code session.** This is Claude's only mechanism for remembering where you left off across sessions.
> Format: newest entry on top. Keep entries terse.

---

## Current Task

**V0.1 — Internal Alpha** (auth foundation + kod tabanı temizliği + lokal/cloud Supabase senkronu).

**Detaylı adım adım to-do list:** [`docs/V0_1_TODO.md`](docs/V0_1_TODO.md)

Bu dosya 7 blok halinde yapılması gerekenleri sıralıyor:
1. Cloud Supabase senkronu (1 gün)
2. Aşama 0 temizliği — Firebase pods, provider, dio, typo'lar (1–2 gün)
3. Auth sealed state migration (2–3 gün)
4. Auth provider testleri (2 gün)
5. Router redirect guard (1 gün)
6. Splash + bootstrap (1 gün)
7. Smoke test = definition of done (1 gün)

**Toplam tahmini süre:** 8–11 gün (haftada ~15 saat çalışma).

**V0.1 bittiğinde:** auth uçtan uca çalışıyor, kod tabanı temiz, lokal Docker ↔ cloud Supabase senkron. Sonrası V0.2 (resimli tarif paylaşımı).

---

## Roadmap (V0.1 → V3.0)

Detayı için Claude'a "V0 V1 V2 V3 planı" diye sor. Özet:

| Versiyon | Hedef | Süre tahmini |
|---|---|---|
| **V0.1** Internal alpha | Auth + temizlik + seed feed | 2 hafta |
| **V0.2** F&F alpha | Resimli tarif paylaşımı + profil | 3–4 hafta |
| **V0.5** Closed beta | Like, save, comment, follow, view tracking | 5–6 hafta |
| **V1.0** Public launch | Auto-kalori, rozet, App Store + Play Store | 4–6 hafta |
| **V1.1** Stabilization | Bug fix + onboarding + comment reply | 3–4 hafta |
| **V1.5** Engagement | Push, trending, multi-language | 4–5 hafta |
| **V2.0** Power user | Video, custom lists, moderation, threaded comments | 6–8 hafta |
| **V2.5** Growth | Referral, sharable cards, challenges | 4–6 hafta |
| **V3.0** Differentiation | AI assistant, meal planner, recommendations | 3–4 ay |

---

## Backlog (V0.1 sonrası — V0.2 başlangıcı için)

1. **Image upload pipeline** — `flutter_image_compress` ile cihazda sıkıştır → `recipe-media` bucket'a yükle → `recipe_media` satırı ekle.
2. **Create recipe wizard** — 4 adım: başlık+kategori → malzemeler → adımlar → görseller + yayınla.
3. **Status workflow** — draft → published. Kendi tarifini düzenle/sil.
4. **Profil sayfası (kendi)** — avatar, display_name, bio, "Tariflerim" 3-kolon grid.
5. **Kategori filtresi** (tek seçim).
6. **Search migration** — `pg_trgm` GIN on `recipes.title` (basit) veya `tsvector` (daha sağlam).
7. **Recently viewed** — `shared_preferences` ile son 10 tarif id'si (sunucu tablosu yok).
8. **10–15 tarif elle seed** — `supabase/seed.sql`'a ekle.

### V0.5 için (henüz başlama)
- `recipe_likes`, `recipe_favorites`, `follows`, `comments` migration'ları + counter trigger'ları
- View tracking (3sn debounce + RPC)
- Crash reporting (Sentry / Supabase log)
- 6 temel analytics event'i

### V1.0 için (sırada beklesin)
- `ingredients`'a nutrition kolonları + `compute_recipe_nutrition()` function + trigger
- Rozet sistemi (`badges` + `user_badges`)
- Account deletion + password reset + email verification
- Hosted Supabase production'a tam geçiş, CI migration push

### Standing technical debt (her versiyonda göz at)
- Feature layout standardizasyonu (`model/service/state/viewmodel/view/widget`).
- Keyset pagination disiplini (offset kullanma).
- Comment depth cap + rate limiting (V0.5 + V1.0'da pekiştir).

---

## Completed

- **2026-05-11** — Senior architecture review delivered. Files created: `CLAUDE.md` (rewritten), `PRD.md`, `PROGRESS.md`, `docs/ARCHITECTURE_REVIEW.md`, `docs/prompts/CLAUDE_CODE_SESSION_PROMPT.md`.
- **2026-05-05** — `alter_ingredients_add_emoji` migration.
- **2026-05-05** — `storage_buckets`, `recipe_media`, `recipe_steps`, `recipe_categories`, `profiles_recipes_count_trigger`.
- **2026-05-04** — `recipes`, `recipe_ingredients`, `categories`, `profiles`, init extensions migrations.

---

## Decisions Log

- **2026-05-11** — MVP cuts confirmed: AI assistant, custom favorite lists, multi-level threaded comments, recipe rating, in-app chat. See `PRD.md` §5.7.
- **2026-05-11** — Counter columns will always be denormalized + trigger-maintained, never client-writable. Pattern set in `recipes` migration.
- **2026-05-11** — Recipe feed pagination = keyset on `(published_at, id)`. Offset is banned.
- **2026-05-11** — Calorie compute is server-side via Postgres function. Client never computes nutrition.

---

## Open Questions (need user decision)

- [ ] Why are Firebase pods in iOS? FCM push later, or leftover? (Blocks decision on whether to delete `firebase.json`.)
- [ ] Single "favorites" set for MVP, OR ship custom lists day-one? (PRD says single. Confirm.)
- [ ] Video uploads in MVP or push to M1? (Storage cost question.)
- [ ] Admin/moderator role: separate role + dashboard, or just a `is_admin` boolean on `profiles` for MVP?

---

## How to use this file

- **At session start:** Claude reads this and offers to resume the top of `## Current Task` or `## Backlog`.
- **At session end:** Claude must move finished items from "Current Task" → "Completed" with today's date, and update "Current Task" + "Next planned task".
- **Decisions Log** entries are appended whenever a non-trivial choice gets locked in. Never edited later — write a new entry that supersedes.
