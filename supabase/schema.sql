-- ============================================================
-- AVG HOUSE - Schéma Supabase
-- À exécuter dans : Supabase Dashboard > SQL Editor
-- ============================================================

-- 1. TABLE PRODUITS
create table if not exists produits (
  id uuid default gen_random_uuid() primary key,
  nom text not null,
  description text,
  prix decimal(10,2) not null,
  categorie text check (categorie in ('Maroquinerie', 'Cosmétiques', 'Accessoires', 'Sur Mesure')),
  image_url text,
  stock int default 0,
  actif boolean default true,
  created_at timestamp with time zone default now(),
  updated_at timestamp with time zone default now()
);

-- 2. TABLE COMMANDES
create table if not exists commandes (
  id uuid default gen_random_uuid() primary key,
  client_nom text not null,
  client_email text not null,
  client_telephone text,
  produit_id uuid references produits(id) on delete set null,
  produit_nom text, -- copie du nom au moment de la commande
  quantite int default 1,
  montant decimal(10,2),
  statut text default 'en attente' check (statut in ('en attente', 'confirmée', 'expédiée', 'livrée', 'annulée')),
  notes text,
  created_at timestamp with time zone default now()
);

-- 3. TABLE MESSAGES CONTACT
create table if not exists messages (
  id uuid default gen_random_uuid() primary key,
  nom text not null,
  email text not null,
  sujet text,
  contenu text not null,
  lu boolean default false,
  created_at timestamp with time zone default now()
);

-- 4. TABLE STATS VISITES (optionnel, leger)
create table if not exists visites (
  id uuid default gen_random_uuid() primary key,
  page text default 'accueil',
  date date default current_date,
  count int default 1
);

-- ============================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================

-- Activer RLS sur toutes les tables
alter table produits enable row level security;
alter table commandes enable row level security;
alter table messages enable row level security;
alter table visites enable row level security;

-- Produits : lecture publique (pour le site vitrine)
create policy "Produits lisibles publiquement"
  on produits for select
  using (actif = true);

-- Produits : écriture uniquement pour les admins authentifiés
create policy "Produits modifiables par admin"
  on produits for all
  using (auth.role() = 'authenticated');

-- Commandes : insérables par tous (formulaire public), lisibles par admin
create policy "Commandes créables publiquement"
  on commandes for insert
  with check (true);

create policy "Commandes lisibles par admin"
  on commandes for select
  using (auth.role() = 'authenticated');

create policy "Commandes modifiables par admin"
  on commandes for update
  using (auth.role() = 'authenticated');

-- Messages : insérables par tous, lisibles par admin
create policy "Messages créables publiquement"
  on messages for insert
  with check (true);

create policy "Messages lisibles par admin"
  on messages for select
  using (auth.role() = 'authenticated');

create policy "Messages modifiables par admin"
  on messages for update
  using (auth.role() = 'authenticated');

-- Visites : lecture/écriture publique
create policy "Visites accessibles publiquement"
  on visites for all
  using (true);

-- ============================================================
-- FONCTION : mise à jour auto de updated_at
-- ============================================================
create or replace function update_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

create trigger produits_updated_at
  before update on produits
  for each row execute function update_updated_at();

-- ============================================================
-- DONNÉES DE TEST (optionnel - à supprimer en prod)
-- ============================================================
insert into produits (nom, description, prix, categorie, stock) values
  ('Sac à Main Tigresse', 'Motif audacieux, cuir premium, finitions artisanales', 15.00, 'Maroquinerie', 5),
  ('Sac à Main Beige', 'Élégance intemporelle, compartiments pratiques', 10.00, 'Maroquinerie', 3),
  ('Huile Essentielle 50ml', 'Pure et naturelle, formulation exclusive', 10.00, 'Cosmétiques', 10),
  ('Musc Amirah 5ml', 'Huile de parfum concentrée', 5.00, 'Cosmétiques', 15);
