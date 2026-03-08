# AVG HOUSE — V2 Dashboard Admin

## 📁 Structure ajoutée

```
avg-house/
├── index.html                  ← site public (existant)
├── images/                     ← images (existant)
│
├── admin/
│   ├── index.html              ← page de login admin
│   └── dashboard.html          ← dashboard complet
│
├── supabase/
│   └── schema.sql              ← script SQL à exécuter dans Supabase
│
└── js/
    └── supabase.js             ← référence client (optionnel si CDN)
```

---

## 🚀 Mise en place

### 1. Créer le projet Supabase
1. Aller sur https://supabase.com → New Project
2. Choisir un nom (ex: `avg-house`) et une région (ex: `eu-west-1`)
3. Récupérer dans **Project Settings > API** :
   - `Project URL` → `SUPABASE_URL`
   - `anon public key` → `SUPABASE_ANON_KEY`

### 2. Créer les tables
1. Aller dans **SQL Editor** sur Supabase
2. Coller et exécuter le contenu de `supabase/schema.sql`

### 3. Créer le compte admin d'Aida
1. Aller dans **Authentication > Users > Invite user**
2. Entrer l'email d'Aida
3. Elle recevra un lien pour définir son mot de passe

### 4. Remplacer les clés dans les fichiers
Remplacer dans `admin/index.html` ET `admin/dashboard.html` :
```js
const SUPABASE_URL = 'https://VOTRE_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'VOTRE_ANON_KEY';
```

### 5. Déployer
- **Site public** (`index.html`) → GitHub Pages (comme actuellement)
- **Dossier admin** → Vercel ou Netlify (recommandé)
  - ou GitHub Pages suffit si pas de backend nécessaire

---

## ✅ Fonctionnalités du dashboard

| Module | Fonctionnalités |
|---|---|
| 🔐 Login | Auth Supabase sécurisée, redirection auto |
| ◇ Produits | Ajouter, modifier, supprimer, masquer un produit |
| ◻ Commandes | Voir toutes les commandes, changer le statut |
| ✉ Messages | Lire les messages du formulaire de contact, marquer comme lu |
| ◉ Stats | Commandes par statut, chiffre d'affaires |

---

## 🔜 Étape suivante (V2 complète)
Rendre le `index.html` **dynamique** : charger les produits depuis Supabase
au lieu du HTML statique hardcodé.
