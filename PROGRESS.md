# PROGRESS.md — Session Log

> **Update this at the end of every Claude Code session.** This is Claude's only mechanism for remembering where you left off across sessions.
> Format: newest entry on top. Keep entries terse.

---

## Current Task

**V0.1 — Internal Alpha** (auth foundation + kod tabanı temizliği + lokal/cloud Supabase senkronu).

**Detaylı adım adım to-do list:** [`docs/V0_1_TODO.md`](docs/V0_1_TODO.md) (kısmen eskimiş — auth sealed state migration ve cleanup büyük ölçüde bitti, bakınız Completed).

### V0.1 kalan iş — bugünden sonra

- [ ] `flutter clean && flutter pub get && cd ios && pod deintegrate && pod install` — stale Firebase pod'larını silmek için (Pods/Firebase* artıkları, plugin tarafından artık çekilmiyor).
- [ ] **Smoke test (V0_1_TODO §7'deki 8 madde).** Özellikle:
  - Anon → email sign-up sonrası `auth.users.id` UUID korunuyor mu? (linkAccount path).
  - Logout → `/createRecipe` route'unda olan kullanıcı `/login`'e otomatik yönlendiriliyor mu? (refreshListenable testi).
  - Anon kullanıcı `/createRecipe` tab'ına basınca: bottom_nav modal'ı çıkar (`Giriş Yapmalısın`) → kabul ederse `/signUp`'a gider.
  - Anon kullanıcı `/listsTabPage` tab'ına basınca: redirect `/login?from=/listsTabPage` yönlendirmeli.
  - `flutter analyze` — `provider` paketi kaldığı için 0 warning hedefi muhtemelen tutmaz; kabul.
- [ ] Cloud Supabase'e migration push (`supabase db push --linked`) — V0_1_TODO Blok 1.
- [ ] Google sign-in lokal Docker'da test edilemiyor; cloud staging projesinde dene veya V0.2'ye ertele.
- [ ] V0.1 done → `git tag v0.1-internal-alpha`.

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

- **2026-05-12** — V0.1 cleanup + router redirect bloğu. Detay:
  - Auth sealed state migration tamamlandığı doğrulandı (`AuthInitial`/`AuthUnauthenticated`/`AuthOtpPending`/`AuthAnonymous`/`AuthAuthenticated` + `AuthBusy` enum). PROGRESS.md "yarı bitmiş" iddiası yanlıştı.
  - `AuthViewmodel.continueAsAnonymous()` eklendi — login/signup misafir butonu artık çalışıyor (önceki `bootstrap()` çağrısı `AuthInitial` dışında erken dönüyordu).
  - **Router redirect Pattern 2** uygulandı: `lib/core/router/go_router_refresh_stream.dart` + `lib/core/router/auth_redirect.dart`. `AppRouter.appRouter` static field'ı `AppRouter.create(AuthViewmodel)` factory'sine çevrildi. `main.dart` GetIt'ten AuthViewmodel alıp inject ediyor.
  - **Splash + login + signup imperative `context.go()` çağrıları kaldırıldı** — navigation artık tek noktadan, router redirect üzerinden akıyor.
  - **AI Asistan tamamen silindi** (`lib/features/ai_asistan_page/` + `/aiAssist` route + bottom nav 4. branch + `BottomTabType.signUp` enum değeri). Bottom nav artık 4 sekmeli: home, listsTabPage, createRecipe, account.
  - **`/verificationCode` route'u app_router'a eklendi** (forgot_password ekranından push'lanıyor; AuthOtpPending pin'i defansif).
  - **Firebase artıkları silindi**: `firebase.json`, `ios/Runner/GoogleService-Info.plist` kaldırıldı. `ios/Pods/Firebase*` stale (Podfile'da Firebase referansı yok, sonraki `pod install` temizleyecek). `AppDelegate.swift` zaten Firebase init içermiyor.
  - **Typo rename'leri**: `lib/features/create_recipe_page/intites/` → `entities/`, `lib/features/ingredient/services/` → `service/`. 4 import güncellendi.
- **2026-05-11** — Senior architecture review delivered. Files created: `CLAUDE.md` (rewritten), `PRD.md`, `PROGRESS.md`, `docs/ARCHITECTURE_REVIEW.md`, `docs/prompts/CLAUDE_CODE_SESSION_PROMPT.md`.
- **2026-05-05** — `alter_ingredients_add_emoji` migration.
- **2026-05-05** — `storage_buckets`, `recipe_media`, `recipe_steps`, `recipe_categories`, `profiles_recipes_count_trigger`.
- **2026-05-04** — `recipes`, `recipe_ingredients`, `categories`, `profiles`, init extensions migrations.

---

## Decisions Log

- **2026-05-12** — **Router redirect = Pattern 2 (redirect + refreshListenable).** Soft prompts (anon kullanıcının like butonu görmesi gibi) Pattern 4 ile V0.5'te eklenecek. `BlocListener + context.go()` (Pattern 3) anti-pattern olarak reddedildi: deep link kırar, geri tuşu kafa karıştırır.
- **2026-05-12** — **Korumalı route'lar V0.1**: `/createRecipe`, `/account`, `/listsTabPage`. Anon `/listsTabPage`'e basarsa `/login?from=/listsTabPage`'e gider (V0.5'te empty state ile soft prompt'a geçilecek).
- **2026-05-12** — **Karma routing felsefesi**: `AuthInitial` → /splash, `AuthOtpPending` → /verificationCode pin'leri restrictive; geri kalan state'lerde permissive.
- **2026-05-12** — **Misafir butonu (continue as anonymous) state-conditional**: `AuthAnonymous`'ta gizli (zaten anon), `AuthUnauthenticated`'da görünür ve `continueAsAnonymous()` çağırır. `bootstrap()` çağrısı (eski) `AuthInitial` dışında erken döndüğü için kırıktı.
- **2026-05-12** — **Firebase MVP kapsamı dışı.** FCM yerine V1'de push notification gerekirse Supabase Edge Function + native APNs/FCM bridge yolu seçilecek. `firebase.json` + iOS Firebase artıkları silindi.
- **2026-05-12** — **`provider` paketi V0.1'de kalıyor.** `ThemeProvider` → `ThemeCubit` port'u V0.2'de `RecipeFeedCubit` yazılırken yapılacak. Sebep: V0.1 done tanımını "auth uçtan uca + cleanup" ile sınırlı tutmak.
- **2026-05-11** — MVP cuts confirmed: AI assistant, custom favorite lists, multi-level threaded comments, recipe rating, in-app chat. See `PRD.md` §5.7.
- **2026-05-11** — Counter columns will always be denormalized + trigger-maintained, never client-writable. Pattern set in `recipes` migration.
- **2026-05-11** — Recipe feed pagination = keyset on `(published_at, id)`. Offset is banned.
- **2026-05-11** — Calorie compute is server-side via Postgres function. Client never computes nutrition.

---

## Open Questions (need user decision)

- [x] ~~Why are Firebase pods in iOS?~~ → **2026-05-12**: V0.1'de Firebase silindi, push notification V1'de Supabase tarafında ele alınacak.
- [ ] Single "favorites" set for MVP, OR ship custom lists day-one? (PRD says single. Confirm.)
- [ ] Video uploads in MVP or push to M1? (Storage cost question.)
- [ ] Admin/moderator role: separate role + dashboard, or just a `is_admin` boolean on `profiles` for MVP?

---

## How to use this file

- **At session start:** Claude reads this and offers to resume the top of `## Current Task` or `## Backlog`.
- **At session end:** Claude must move finished items from "Current Task" → "Completed" with today's date, and update "Current Task" + "Next planned task".
- **Decisions Log** entries are appended whenever a non-trivial choice gets locked in. Never edited later — write a new entry that supersedes.
