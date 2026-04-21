# ShopHub - Application Flutter de Shopping avec Supabase

Une application Flutter professionnelle et scalable pour faire des achats en ligne, intégrée avec Supabase comme backend complet.

## 📋 Table des matières

- [Architecture du projet](#architecture-du-projet)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration Supabase](#configuration-supabase)
- [Utilisation](#utilisation)
- [Structure des données](#structure-des-données)
- [Fonctionnalités](#fonctionnalités)
- [Bonnes pratiques](#bonnes-pratiques)

---

## 🏗️ Architecture du projet

```
lib/
├── core/
│   ├── config/
│   │   └── supabase_config.dart          # Configuration Supabase
│   ├── constants/
│   │   └── app_constants.dart             # Constantes de l'app
│   └── theme/
│       └── app_theme.dart                 # Thème Material
├── models/
│   ├── user_model.dart                    # Modèle Utilisateur
│   ├── product_model.dart                 # Modèle Produit
│   ├── cart_item_model.dart              # Modèle Article Panier
│   ├── order_model.dart                  # Modèle Commande
│   └── order_item_model.dart             # Modèle Article Commande
├── services/
│   ├── auth_service.dart                 # Service Authentification
│   ├── product_service.dart              # Service Produits
│   ├── cart_service.dart                 # Service Panier
│   └── order_service.dart                # Service Commandes
├── screens/
│   ├── auth/
│   │   ├── splash_screen.dart            # Écran de démarrage
│   │   ├── login_screen.dart             # Connexion
│   │   └── register_screen.dart          # Inscription
│   ├── home/
│   │   ├── home_screen.dart              # Liste des produits
│   │   └── product_details_screen.dart   # Détails produit
│   ├── cart/
│   │   └── cart_screen.dart              # Panier
│   ├── checkout/
│   │   └── checkout_screen.dart          # Paiement/Commande
│   └── orders/
│       └── orders_screen.dart            # Historique commandes
├── widgets/
│   ├── product_card.dart                 # Carte produit
│   ├── cart_item_card.dart              # Carte article panier
│   ├── custom_button.dart                # Bouton personnalisé
│   ├── loading_widget.dart              # Widget chargement
│   └── error_widget.dart                # Widget erreur
└── main.dart                             # Point d'entrée
```

---

## 📦 Prérequis

- Flutter 3.11+
- Dart 3.11+
- Compte Supabase gratuit (https://supabase.com)
- Git

---

## 🚀 Installation

### 1. Configurez votre environnement Flutter

```bash
flutter pub get
```

### 2. Créez un projet Supabase

1. Allez sur https://app.supabase.com
2. Créez un nouveau projet
3. Attendez que le projet soit initialisé
4. Allez dans **Settings → API** pour récupérer vos clés

### 3. Exécutez le SQL Supabase

1. Dans la console Supabase, allez dans **SQL Editor**
2. Créez une nouvelle requête
3. Copiez et collez le SQL complète (voir section [Configuration Supabase](#configuration-supabase))
4. Exécutez la requête

### 4. Configurez les clés Supabase

Ouvrez `lib/core/config/supabase_config.dart` et remplacez les valeurs :

```dart
const String supabaseUrl = 'https://your-project.supabase.co';
const String supabaseAnonKey = 'your-anon-key-here';
```

### 5. Lancez l'application

```bash
flutter run
```

---

## 🔐 Configuration Supabase

### SQL Complet à Exécuter

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

-- Activer Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- Politiques RLS
CREATE POLICY "Users can view their own profile" 
ON profiles FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can update their own profile" 
ON profiles FOR UPDATE USING (auth.uid() = id);

CREATE POLICY "Users can insert their profile" 
ON profiles FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Anyone can view active products" 
ON products FOR SELECT USING (is_active = TRUE);

CREATE POLICY "Users can view their own cart items" 
ON cart_items FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert cart items" 
ON cart_items FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can update their own cart items" 
ON cart_items FOR UPDATE USING (user_id = auth.uid());

CREATE POLICY "Users can delete their own cart items" 
ON cart_items FOR DELETE USING (user_id = auth.uid());

CREATE POLICY "Users can view their own orders" 
ON orders FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "Users can insert orders" 
ON orders FOR INSERT WITH CHECK (user_id = auth.uid());

CREATE POLICY "Users can view their order items" 
ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id AND orders.user_id = auth.uid())
);

-- Indices
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_cart_items_user_id ON cart_items(user_id);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- Insérer des produits de test
INSERT INTO products (name, description, price, category, image_url, stock, is_active) VALUES
('T-Shirt Bleu Premium', 'T-shirt en coton premium très confortable', 29.99, 'Vêtements', 'https://via.placeholder.com/300x300?text=T-Shirt', 50, TRUE),
('Jean Noir Slim', 'Jean noir de haute qualité, coupe slim moderne', 59.99, 'Vêtements', 'https://via.placeholder.com/300x300?text=Jean', 40, TRUE),
('Chaussures de Sport', 'Chaussures légères avec semelle antichoc', 89.99, 'Chaussures', 'https://via.placeholder.com/300x300?text=Chaussures', 35, TRUE),
('Montre Numérique', 'Montre avec écran LCD, résistante à l''eau', 49.99, 'Accessoires', 'https://via.placeholder.com/300x300?text=Montre', 60, TRUE),
('Casquette Noire', 'Casquette en coton ajustable pour tous les jours', 19.99, 'Accessoires', 'https://via.placeholder.com/300x300?text=Casquette', 100, TRUE),
('Sac à Dos Premium', 'Sac spacieux avec plusieurs compartiments', 79.99, 'Accessoires', 'https://via.placeholder.com/300x300?text=Sac', 45, TRUE);
```

### Vérifier les Clés

Dans **Settings → API** :
- Copier `Project URL` → `supabaseUrl`
- Copier `anon public` key → `supabaseAnonKey`

---

## 📚 Utilisation

### Flux Utilisateur

1. **Écran de démarrage** → Vérifie si l'utilisateur est connecté
2. **Authentification** → Inscription/Connexion
3. **Accueil** → Liste des produits
4. **Détails** → Voir les détails d'un produit
5. **Panier** → Gérer les articles
6. **Commande** → Remplir les infos de livraison
7. **Historique** → Voir mes commandes

### Exemples d'Utilisation

#### Récupérer les produits

```dart
final productService = ProductService();
final products = await productService.getActiveProducts();
```

#### Ajouter au panier

```dart
final cartService = CartService();
await cartService.addToCart(
  userId: userId,
  productId: productId,
  quantity: 1,
);
```

#### Créer une commande

```dart
final orderService = OrderService();
await orderService.createOrderFromCart(
  userId: userId,
  customerName: 'Jean Dupont',
  customerEmail: 'jean@example.com',
  customerAddress: '123 Rue de la Paix',
  customerPhone: '0612345678',
  cartItems: cartItems,
  totalAmount: 150.50,
);
```

---

## 📊 Structure des Données

### Authentification

- Supabase gère automatiquement `auth.users`
- Colonne `profiles` liée à `auth.users(id)`

### Produits

```
id: UUID
name: TEXT
description: TEXT
price: DECIMAL
category: TEXT
image_url: TEXT (nullable)
stock: INTEGER
is_active: BOOLEAN
```

### Panier

```
id: UUID
user_id: UUID (FK profiles)
product_id: UUID (FK products)
quantity: INTEGER
added_at: TIMESTAMP
```

### Commandes

```
id: UUID
user_id: UUID (FK profiles)
total_amount: DECIMAL
order_status: TEXT (pending|confirmed|shipped|delivered|cancelled)
customer_name: TEXT
customer_email: TEXT
customer_address: TEXT
customer_phone: TEXT
```

---

## ✨ Fonctionnalités

✅ **Authentification**
- Inscription avec email/mot de passe
- Connexion sécurisée
- Déconnexion
- Session persistante

✅ **Produits**
- Affichage de la liste
- Recherche/Filtrage (prêt pour extension)
- Catégorisation
- Gestion du stock

✅ **Panier**
- Ajouter/Supprimer articles
- Modifier les quantités
- Calcul du total

✅ **Commandes**
- Création de commandes
- Historique des commandes
- Suivi du statut

✅ **Sécurité**
- Row Level Security (RLS) activé
- Authentification obligatoire
- Données isolées par utilisateur

---

## 🎯 Bonnes Pratiques

### Services
- Chaque service gère une entité
- Méthodes claires et documentées
- Gestion des erreurs

### Models
- Sérialisation/Désérialisation en JSON
- Calculs utiles (prix total, etc.)
- Immuabilité

### UI
- Séparation écrans/widgets
- Loading/Error/Empty states
- Responsive design

### Code
- Noms explicites
- Pas de code dupliqué
- Commentaires quand nécessaire

---

## 🚀 Prochaines Étapes (Évolutions Futures)

1. **State Management** → Intégrer Riverpod ou Provider
2. **Images** → Supabase Storage pour les photos produits
3. **Paiement** → Intégrer Stripe/PayPal
4. **Notifications** → Push notifications
5. **Favoris** → Système de favoris
6. **Recherche avancée** → Filtres multiples
7. **Avis** → Système de commentaires
8. **Panier persistant** → Cache local
9. **Multi-langue** → i18n
10. **Admin Panel** → Gestion des produits

---

## 📝 Licences

MIT License - Libre d'utilisation

---

## 📧 Support

Pour toute question, consultez :
- Documentation Flutter : https://flutter.dev/docs
- Documentation Supabase : https://supabase.com/docs
