# 🚀 Guide de Configuration - ShopHub + Supabase

Guide pas à pas pour configurer l'application ShopHub complètement.

## ÉTAPE 1 : Créer un compte Supabase

1. Allez sur https://app.supabase.com
2. Cliquez sur "Sign up"
3. Inscrivez-vous avec GitHub ou email
4. Vérifiez votre email

## ÉTAPE 2 : Créer un projet Supabase

1. Cliquez sur "New Project"
2. Donnez un nom : `shophub`
3. Créez un mot de passe fort
4. Choisissez la région la plus proche
5. Cliquez sur "Create new project"
6. ⏳ Attendez 3-5 minutes que le projet s'initialise

## ÉTAPE 3 : Récupérer les clés d'API

Quand le projet est prêt :

1. Allez dans **Settings** (en bas à gauche)
2. Cliquez sur **API**
3. Copiez :
   - **Project URL** (commence par `https://`)
   - **anon public** (la clé longue)

## ÉTAPE 4 : Exécuter le SQL

1. Dans Supabase, allez dans **SQL Editor** (à gauche)
2. Cliquez sur **+ New query**
3. Collez TOUT le code SQL ci-dessous
4. Cliquez sur **Run** (le bouton bleu Play)
5. ✅ Attendez que tout s'exécute sans erreur

### Code SQL Complet

```sql
-- Supprimer les tables si elles existent
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS cart_items CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS profiles CASCADE;

-- Table profiles
CREATE TABLE profiles (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT NOT NULL,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table products
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL CHECK (price > 0),
  category TEXT NOT NULL,
  image_url TEXT,
  stock INTEGER DEFAULT 0 CHECK (stock >= 0),
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table cart_items
CREATE TABLE cart_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id) ON DELETE CASCADE,
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  added_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, product_id)
);

-- Table orders
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount > 0),
  order_status TEXT DEFAULT 'pending' CHECK (order_status IN ('pending', 'confirmed', 'shipped', 'delivered', 'cancelled')),
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  customer_address TEXT NOT NULL,
  customer_phone TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Table order_items
CREATE TABLE order_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id UUID NOT NULL REFERENCES products(id),
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price_at_purchase DECIMAL(10, 2) NOT NULL CHECK (price_at_purchase > 0),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Activer Row Level Security (RLS)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Politiques de sécurité (RLS Policies)

-- Profiles
CREATE POLICY "Users can view their own profile" 
ON profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their profile" 
ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

-- Products
CREATE POLICY "Anyone can view active products" 
ON products FOR SELECT USING (is_active = TRUE);

-- Cart items
CREATE POLICY "Users can view their own cart items" 
ON cart_items FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert cart items" 
ON cart_items FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own cart items" 
ON cart_items FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Users can delete their own cart items" 
ON cart_items FOR DELETE USING (user_id = auth.uid());

-- Orders
CREATE POLICY "Users can view their own orders" 
ON orders FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert orders" 
ON orders FOR INSERT WITH CHECK (user_id = auth.uid());

-- Order items
CREATE POLICY "Users can view their order items" 
ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())
);

-- Créer des indices
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Insérer 6 produits de test
INSERT INTO products (name, description, price, category, image_url, stock, is_active) VALUES
('T-Shirt Bleu Premium', 'T-shirt en coton premium très confortable et durable', 29.99, 'Vêtements', 'https://via.placeholder.com/300x300?text=T-Shirt', 50, TRUE),
('Jean Noir Slim', 'Jean noir de haute qualité, coupe slim moderne et tendance', 59.99, 'Vêtements', 'https://via.placeholder.com/300x300?text=Jean', 40, TRUE),
('Chaussures de Sport', 'Chaussures légères avec semelle antichoc pour tous les sports', 89.99, 'Chaussures', 'https://via.placeholder.com/300x300?text=Chaussures', 35, TRUE),
('Montre Numérique', 'Montre avec écran LCD, résistante à l''eau jusqu''à 50m', 49.99, 'Accessoires', 'https://via.placeholder.com/300x300?text=Montre', 60, TRUE),
('Casquette Noire', 'Casquette en coton ajustable parfaite pour tous les jours', 19.99, 'Accessoires', 'https://via.placeholder.com/300x300?text=Casquette', 100, TRUE),
('Sac à Dos Premium', 'Sac spacieux avec plusieurs compartiments et rangements', 79.99, 'Accessoires', 'https://via.placeholder.com/300x300?text=Sac', 45, TRUE);
```

✅ Si tout passe sans erreur, vous serez à l'étape suivante.

## ÉTAPE 5 : Configurer les clés dans Flutter

1. Ouvrez `lib/core/config/supabase_config.dart`
2. Remplacez les valeurs :

```dart
const String supabaseUrl = 'VOTRE_PROJECT_URL_ICI';
const String supabaseAnonKey = 'VOTRE_ANON_KEY_ICI';
```

Exemple :
```dart
const String supabaseUrl = 'https://abc123def456.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ...';
```

## ÉTAPE 6 : Installer les dépendances Flutter

```bash
flutter pub get
```

## ÉTAPE 7 : Lancer l'application

```bash
flutter run
```

## ÉTAPE 8 : Tester l'application

### Test 1 : Inscription

1. Cliquez sur "Inscrivez-vous"
2. Entrez :
   - Nom : `Jean Dupont`
   - Email : `jean@example.com`
   - Mot de passe : `SecurePass123!`
   - Confirmer : `SecurePass123!`
3. Cliquez sur "Inscription"
4. ✅ Vous devriez arriver à la home

### Test 2 : Voir les produits

1. La page d'accueil montre 6 produits
2. Cliquez sur un produit pour voir les détails
3. Testez "Ajouter au panier"

### Test 3 : Panier

1. Cliquez sur l'icône panier en haut
2. Vous devriez voir vos articles
3. Modifiez les quantités
4. Cliquez sur "Procéder au paiement"

### Test 4 : Commande

1. Remplissez le formulaire
2. Cliquez sur "Confirmer la Commande"
3. ✅ Vous verrez "Commande créée avec succès!"

### Test 5 : Historique

1. Cliquez sur le menu (3 points)
2. Sélectionnez "Mes Commandes"
3. Vous verrez votre commande

## 🎯 Vérifications dans Supabase

Pour confirmer que tout fonctionne :

### Vérifier les utilisateurs (Auth Users)

1. Allez dans **Authentication** (à gauche)
2. Cliquez sur **Users**
3. Vous devriez voir votre utilisateur créé

### Vérifier les profils

1. Allez dans **SQL Editor**
2. Exécutez :
```sql
SELECT * FROM profiles;
```
3. Vous verrez votre profil

### Vérifier les commandes

1. Exécutez :
```sql
SELECT * FROM orders;
```
2. Vous verrez vos commandes

### Vérifier les articles de commande

1. Exécutez :
```sql
SELECT * FROM order_items;
```
2. Vous verrez les articles

## ❌ Dépannage

### Erreur : "Invalid API Key"
- Vérifiez que vous avez copié la bonne clé anon
- Vérifiez que vous avez copié l'URL complète

### Erreur : "Table does not exist"
- Le SQL n'a pas été exécuté correctement
- Refaites l'ÉTAPE 4

### Erreur : "Permission denied"
- Les RLS policies n'ont pas été créées
- Vérifiez qu'elles sont dans le SQL

### Erreur : "User already exists"
- Utilisez une autre adresse email pour tester
- Ou supprimez l'utilisateur dans **Authentication > Users**

## 📱 Plateformes Supportées

- ✅ Android
- ✅ iOS
- ✅ Web (expérimental)
- ✅ Windows/macOS (expérimental)

## 🎓 Points Clés Appris

Après ce config, vous comprenez :

1. ✅ Comment initialiser Supabase dans Flutter
2. ✅ Comment structurer une app avec services/models
3. ✅ Comment faire une authentification
4. ✅ Comment gérer les données avec RLS
5. ✅ Comment organiser les écrans
6. ✅ Comment créer une vraie app production-ready

## 🚀 Prochaines Étapes

Après ce setup, vous pouvez :

1. Ajouter **Riverpod** pour le state management
2. Ajouter **images storage** avec Supabase Storage
3. Intégrer un système de **paiement**
4. Ajouter des **favoris**
5. Implémenter la **recherche avancée**

---

**Vous êtes maintenant prêt à utiliser ShopHub! 🎉**
