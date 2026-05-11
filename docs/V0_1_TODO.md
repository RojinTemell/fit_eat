# V0.1 — Internal Alpha TO-DO List

> **Hedef:** Auth uçtan uca çalışıyor, kod tabanı temizlenmiş, lokal Docker ↔ cloud Supabase senkron.
> **Kullanıcı sayısı:** 1 (sen).
> **Definition of done:** Blok 7'deki smoke test'in tüm maddeleri tik atılmış.
> **Tahmini süre:** 8–11 gün (haftada 15 saat çalışma ile ~2 hafta).

---

## Mevcut durum tespiti (V0.1 başlangıcında)

Auth iskeleti **yarı bitmiş** ve iki nesil kod çakışmış durumda:

- `AuthState` sealed class yapısı doğru kurulmuş (`AuthInitial`, `AuthUnauthenticated`, `AuthOtpPending`, `AuthAnonymous`, `AuthAuthenticated`) + `AuthBusy` enum. Senior seviyede tasarım.
- AMA `AuthViewmodel` bu sealed class'ları kullanmıyor — hâlâ `state.copyWith(isLoading: ...)` + `AuthStatus` enum mantığıyla. Yarı-refactor durumu.
- `Splash` da eski modeli kullanıyor (`state.isLoading`, `state.status`).
- `supabase/config.toml`'da `enable_anonymous_sign_ins = false` — ama kod açık varsayıyor. Silent bug.
- `app_router.dart`'ta redirect guard yok. Anon kullanıcı `/createRecipe`'ye direkt gidiyor.
- `AiAssist` hâlâ bottom nav'da bir branch — V0.1 kapsamı dışı.
- Cloud Supabase migration'ları lokal Docker'ın gerisinde, push edilmemiş.

---

## Blok 1 — Cloud Supabase senkronizasyonu (1 gün)

> Auth davranışı lokal Docker'da test ettiğinle cloud'daki farklı çıkarsa hangi tarafın hatalı olduğunu bilemezsin. Tek doğruluk kaynağı: migration dosyalarındaki SQL.

- [ ] **1.1** Terminalde `supabase link --project-ref <senin-cloud-ref>` çalıştır. Zaten link edilmişse `supabase projects list` ile aktif link'in cloud projene baktığını doğrula.
- [ ] **1.2** Cloud'da mevcut schema'yı kaydet: `supabase db dump --schema public --linked > /tmp/cloud_before.sql`. Güvenlik ağı.
- [ ] **1.3** Lokal ile cloud arasındaki farkı gör: `supabase db diff --linked`. Ekrana dökülen SQL = cloud'a uygulanacak değişiklikler. Mantıksız satır var mı kontrol et.
- [ ] **1.4** Hazırsan push et: `supabase db push --linked`. Hata olursa panik yapma — hata mesajındaki migration dosyası adını not al.
- [ ] **1.5** Push sonrası Supabase Studio'yu aç (cloud dashboard) → Table Editor → `profiles`, `recipes`, `ingredients`, `categories`, `recipe_ingredients`, `recipe_steps`, `recipe_media`, `recipe_categories` tablolarının hepsinin orada olduğunu gözle doğrula.
- [ ] **1.6** Cloud dashboard → Authentication → Providers → **Anonymous Sign-ins** açık mı kontrol et. Kapalıysa aç.
- [ ] **1.7** Cloud dashboard → Storage → bucket'lar var mı bak (`avatars`, `recipe-media` — `20260505083737_storage_buckets.sql` migration'ından).
- [ ] **1.8** `.env`'i ikiye böl: `.env.local` (Docker) ve `.env.production` (cloud). V0.1 boyunca lokal Docker kullan — app cloud'a bağlanmayacak, cloud sadece backup gibi duracak.

---

## Blok 2 — Aşama 0 temizliği (1–2 gün)

> Auth'a girmeden önce 30 dakikalık temizlik vergisi. Sonra her oturum hızlanır.

- [ ] **2.1** **Firebase kararı.** iOS `Pods/` içinde FirebaseAuth/Firestore var, `firebase.json` repo'da. Push notification için mi tutuyorsun?
  - [ ] **Hayır** ise: `firebase.json` sil → `ios/Podfile`'dan Firebase pod referanslarını çıkar → `cd ios && pod deintegrate && pod install` → `flutter clean && flutter pub get && cd ios && pod install`.
  - [ ] **Evet** (FCM için) ise: `pubspec.yaml` başına yorum satırı yaz ("Firebase yalnızca FCM push için"), `firebase_messaging` dependency'sini ekle.
- [ ] **2.2** `pubspec.yaml`'dan **`provider`** paketini kaldır (`flutter_bloc` kullanılıyor). `flutter pub get`.
- [ ] **2.3** `pubspec.yaml`'dan **`dio`** paketini kaldır — eğer Supabase dışında HTTP çağrısı yoksa. `lib/` altında `import 'package:dio'` araması yap.
- [ ] **2.4** **Typo'lar:**
  - [ ] `lib/features/ai_asistan_page/` → `ai_assistant_page` (veya tamamen sil — V3.0'a kadar kullanılmayacak)
  - [ ] `lib/features/create_recipe_page/intites/` → `entities`
  - [ ] `lib/features/ingredient/services/` → `service/` (diğerleriyle tutarlı)
- [ ] **2.5** `app_router.dart` içinden `/aiAssist` route'unu sil veya yoruma al. Bottom nav 4. branch'i `account`/`profile` ile değiştir.
- [ ] **2.6** `flutter analyze` çalıştır. Warning sayısını defterine yaz. Hedef: V0.1 sonunda **0 warning**.

---

## Blok 3 — Auth sealed state migration'ı (2–3 gün)

> Yarı yazılmış sealed class yapısını bitirmek. Yoksa enum ve sealed class iki paralel state mantığı olarak yaşar.

- [ ] **3.1** **Karar:** sealed class'lara geç. Sebep: pattern matching ile compile-time güvenlik + `AuthOtpPending` gibi geçici state'ler enum'a sığmaz + `AuthBusy` zaten yazılmış.
- [ ] **3.2** `AuthViewmodel`'i sealed state'e geçir:
  - [ ] `state.copyWith(isLoading: true)` çağrılarını sil
  - [ ] Her method'da pattern matching kullan (`switch (state) { case AuthAnonymous(:final user) => ... }`)
  - [ ] Emit ettiğin state'ler `AuthBusy.signingIn`, `AuthBusy.signingUp` gibi explicit busy değerleri içersin
- [ ] **3.3** `Splash` ekranını sealed state'e adapte et:
  - [ ] `state.isLoading` → `state is AuthInitial || (state has busy != idle)`
  - [ ] `state.status == AuthStatus.unauthenticated` → `state is AuthUnauthenticated`
  - [ ] `context.go('/signUp')` yerine `/login` yönlendirmesi
- [ ] **3.4** `AuthStatus` enum'unu kullanılan tüm yerlerden çıkar, sonra dosyayı sil. `app_user.dart` veya başka model'de geçiyorsa önce çıkar, sonra sil.

---

## Blok 4 — Auth provider testleri (2 gün)

> Üç giriş yolunu tek tek doğrula. Her birinde Supabase Studio'dan `auth.users` tablosunu açıp gerçekten kayıt oluştuğunu gör.

- [ ] **4.1** **Anonymous sign-in:**
  - [ ] `supabase/config.toml` içinde `enable_anonymous_sign_ins = true`, `supabase stop && supabase start`.
  - [ ] `AuthViewmodel.init()` mevcut user yoksa **`signInAnonymously()` çağırıyor mu** kontrol et — şu an çağırmıyor, bu bug.
  - [ ] Telefonu sıfırla, uygulamayı aç → Supabase Studio'da `auth.users` tablosunda yeni anon kullanıcı görüyor olmalısın.
  - [ ] `profiles` tablosunda da otomatik bir satır (trigger sayesinde).
- [ ] **4.2** **Email + password sign-up:**
  - [ ] Sign-up ekranından test@example.com + şifre ile kayıt ol.
  - [ ] `auth.users` ve `profiles`'ta satırlar oluştu mu?
  - [ ] OTP doğrulama: lokal Docker email göndermez. Inbucket UI'a bak: `http://127.0.0.1:54324`.
  - [ ] **Anon → email link** mantığı: anon kullanıcıyken sign-up yaparsan `_repo.linkAccount` çağrılıyor. Aynı user_id korunmalı.
- [ ] **4.3** **Email + password sign-in:**
  - [ ] Doğru şifre → `AuthAuthenticated`.
  - [ ] Yanlış şifre → kullanıcıya gösterilen hata mesajı net mi? `auth_service_impl.dart`'ta hata mapping var ama `Err(ServerFailure())` döndürüyor — mesaj kaybediliyor. Bunu düzelt: `ServerFailure(message: ...)` veya benzeri.
- [ ] **4.4** **Google sign-in:**
  - [ ] Lokal Docker'da Google OAuth karmaşık. V0.1'de cloud staging'e geç sadece Google testi için, veya bu maddeyi V0.5'e ertele.
  - [ ] `google_sign_in: ^7.2.0` yeni majör sürüm — `await GoogleSignIn.instance.initialize(...)` çağrısı var mı kontrol et (7.x'te zorunlu).
- [ ] **4.5** **Logout:**
  - [ ] Settings ekranındaki logout butonu çalışıyor mu? Yoksa minimal bir tane oluştur.
  - [ ] Logout sonrası `AuthAnonymous`'a düş — kullanıcı browse'a devam edebilsin.

---

## Blok 5 — Router redirect guard (1 gün)

> Anon kullanıcı `/createRecipe`'ye gitmemeli. RLS ile insert patlar ama UX kötü.

- [ ] **5.1** `app_router.dart`'a `redirect` parametresi ekle:
  - [ ] `AuthCubit` state'ini oku
  - [ ] Korumalı route listesi: `/createRecipe`, `/account` (profil düzenleme)
  - [ ] Anon ise → `/login`
- [ ] **5.2** Login ekranına "Misafir olarak devam et" butonu — `AuthViewmodel.checkAuth()` çağırır, anon session'a düşer.
- [ ] **5.3** Login sonrası geldiği yere geri dönsün — `state.uri.queryParameters['from']` ile.

---

## Blok 6 — Splash + bootstrap netleştir (1 gün)

- [ ] **6.1** Splash şu anda `addPostFrameCallback` ile `init()` çağırıyor. `init()` mevcut user'ı kontrol ediyor ama **yoksa anon başlatmıyor.** Düzeltme:
  - [ ] Mevcut user var → `AuthAuthenticated` veya `AuthAnonymous`
  - [ ] Yok → `signInAnonymously()` çağır, sonra `AuthAnonymous`
  - [ ] Bu fail ederse → `AuthUnauthenticated`
- [ ] **6.2** Splash'a minimum 1 saniye gecikme ekle — `Future.delayed(Duration(seconds: 1))`.
- [ ] **6.3** Splash crash olursa ne olur? `try/catch` ile sarmalanmış mı kontrol et.

---

## Blok 7 — Smoke test (definition of done) (1 gün)

- [ ] **7.1** Uygulamayı **temiz bir cihazda** (uninstall + reinstall) aç. Splash → otomatik anon → home feed.
- [ ] **7.2** Login → çık → tekrar gir → state korunuyor.
- [ ] **7.3** Yeni hesap oluştur → anon kullanıcı upgrade ediliyor (aynı user_id).
- [ ] **7.4** Logout → tekrar anon'a düşüyor.
- [ ] **7.5** Korumalı route'lara anon ile erişmeye çalış → login'e yönlendiriyor.
- [ ] **7.6** `flutter analyze` → 0 warning.
- [ ] **7.7** `flutter build apk --release` → patlamadan tamamlanıyor.
- [ ] **7.8** Supabase Studio'da `auth.users` ve `profiles` tablolarındaki kayıtların birebir eşleştiğini doğrula. Her auth user'ın bir profile satırı var.

---

## Junior tuzakları (bu V0.1 boyunca dikkat)

1. **Cloud Supabase'i şimdi production gibi kullanma.** Sadece staging gibi düşün. Asıl gelişim hâlâ lokal Docker'da.
2. **Sealed class refactor'ını yarım bırakma.** İki state modeli paralel yaşarsa V0.5'te neyin nereyi tetiklediğini bulamazsın.
3. **Anon → email link mantığını ciddiye al.** Anon kullanıcının verisini sign-up'tan sonra korumalı. Test etmezsen kullanıcı kayıt olunca verisini kaybeder.
4. **Google sign-in V0.1'de zorunlu değil.** Email + anon + logout çalışıyorsa V0.1 done sayılır. Google'u V0.2'ye ertele eğer takılırsan.

---

## Bittiğinde

- [ ] `PROGRESS.md` → V0.1 maddesi "Completed" altına taşı, V0.2 (resimli tarif paylaşımı) "Current Task" olarak işaretle.
- [ ] Git'te tag at: `git tag v0.1-internal-alpha && git push origin v0.1-internal-alpha`.
- [ ] 24 saat dinlen. V0.2'ye başlamadan önce demo videosu çek (kendin için).
