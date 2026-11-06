# elsewhere — putting it online (Vercel + Supabase)

What each piece does
- **Vercel** hosts the website itself (index.html, photos, config.js). Free.
- **Supabase** stores comments, saved-place counts and reactions, and runs the live chat room. Free tier.
- Without Supabase the site still works — comments/likes are then only saved on each person's own phone.

## 1. Create the Supabase project (≈5 min)
1. Go to https://supabase.com → sign in with GitHub or Google → **New project** (pick a region near your users, set a DB password).
2. Left menu **SQL Editor** → **New query** → paste everything in `schema.sql` → **Run**.
3. **Authentication → Sign In / Providers** → turn on **Allow anonymous sign-ins** → Save.
4. **Project Settings → API** (or "API Keys"): copy the **Project URL** and the **anon / publishable** key.
5. Open `config.js` and paste them into `supabaseUrl` and `supabaseAnonKey`. (Never paste the secret / service_role key.)

## 2. Put it on Vercel (≈5 min)
Easiest way, no coding tools:
1. Create a free account at https://github.com → **New repository** (e.g. `elsewhere`), Public or Private.
2. On the repository page click **Add file → Upload files**, drag in everything from this folder
   (index.html, config.js, photos folder, README.md, schema.sql) → **Commit changes**.
3. Go to https://vercel.com → sign in with GitHub → **Add New… → Project** → pick the `elsewhere` repo → **Deploy**.
   (Framework preset: "Other". No build command needed.)
4. A minute later you get a link like `https://elsewhere-xxxx.vercel.app`. Open it on your phone. 🎉
5. Later edits: change a file on GitHub → Vercel redeploys automatically.

Optional: put that link into `siteUrl` in config.js so "Copy place link" uses it.
Optional: custom domain — Vercel → Project → Settings → Domains.

## 3. Make yourself the moderator
1. Open your site once (this creates your anonymous account on that browser).
2. Supabase → **Authentication → Users** → copy your user's ID (newest user).
3. SQL Editor → run: `insert into public.admins (user_id) values ('PASTE-YOUR-ID');`
4. Reload the site — you can now delete any comment and see reports under **You**.

## 4. Before sharing widely (legal checklist)
- Streams: the app only links to the operators' public YouTube/official pages — keep it that way (don't re-host video).
- Photos: Wikimedia Commons, free licenses — keep the "Photo credits" screen (attribution is required by CC BY / BY-SA).
- Add a short Privacy Policy & Terms page (what you store: nickname, comment text, time, anonymous user ID).
- Moderate: check reports regularly; you're responsible for user content on your site.
- If you later let people log in with Gmail: Supabase → Authentication → Providers → Google (needs a Google Cloud OAuth client).

## Costs
Vercel and Supabase both have free plans that are enough for a hobby app; check their pricing pages for current limits. A free Supabase project pauses after a period of inactivity — just press "Restore" in the dashboard.
