# 📊 Schéma de la Base de Données - ShopHub

Ce document détaille toutes les tables de la base de données Supabase utilisée par l'application ShopHub, ainsi que leurs attributs et relations.

---

## 🏗️ Diagramme de Structure (ERD)

- **profiles** (`1`) <--- `PK` ---> (`N`) **orders**
- **profiles** (`1`) <--- `PK` ---> (`N`) **cart_items**
- **profiles** (`1`) <--- `PK` ---> (`N`) **wishlist**
- **products** (`1`) <--- `PK` ---> (`N`) **cart_items**
- **products** (`1`) <--- `PK` ---> (`N`) **order_items**
- **products** (`1`) <--- `PK` ---> (`N`) **wishlist**
- **orders** (`1`) <--- `PK` ---> (`N`) **order_items**

---

## 📋 Détail des Tables

### 1. `profiles`
Stocke les informations personnelles des utilisateurs. Liée directement à l'authentification Supabase.

| Attribut | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` (PK) | Identifiant unique (lié à `auth.users.id`) |
| `email` | `TEXT` | Adresse email de l'utilisateur |
| `full_name` | `TEXT` | Nom complet de l'utilisateur |
| `avatar_url` | `TEXT` | URL de la photo de profil (Stockage Supabase) |
| `created_at` | `TIMESTAMPTZ` | Date de création du profil |
| `updated_at` | `TIMESTAMPTZ` | Date de dernière mise à jour |

---

### 2. `products`
Catalogue des articles disponibles à la vente.

| Attribut | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` (PK) | Identifiant unique du produit |
| `name` | `TEXT` | Nom de l'article |
| `description` | `TEXT` | Description détaillée |
| `price` | `DECIMAL` | Prix unitaire |
| `category` | `TEXT` | Catégorie (Vêtements, Chaussures, etc.) |
| `image_url` | `TEXT` | URL de l'image du produit |
| `stock` | `INTEGER` | Quantité disponible en stock |
| `is_active` | `BOOLEAN` | Si le produit est visible en magasin |
| `created_at` | `TIMESTAMPTZ` | Date d'ajout au catalogue |
| `updated_at` | `TIMESTAMPTZ` | Date de modification |

---

### 3. `cart_items`
Contient les articles ajoutés temporairement par les utilisateurs dans leur panier.

| Attribut | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` (PK) | Identifiant unique de la ligne panier |
| `user_id` | `UUID` (FK) | Utilisateur propriétaire (Référence `profiles.id`) |
| `product_id` | `UUID` (FK) | Produit concerné (Référence `products.id`) |
| `quantity` | `INTEGER` | Quantité sélectionnée |
| `added_at` | `TIMESTAMPTZ` | Date d'ajout au panier |

---

### 4. `wishlist`
Liste de souhaits (favoris) des utilisateurs.

| Attribut | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` (PK) | Identifiant unique |
| `user_id` | `UUID` (FK) | Utilisateur (Référence `profiles.id`) |
| `product_id` | `UUID` (FK) | Produit favori (Référence `products.id`) |
| `created_at` | `TIMESTAMPTZ` | Date de mise en favori |

---

### 5. `orders`
Historique des transactions validées.

| Attribut | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` (PK) | Identifiant unique de la commande |
| `user_id` | `UUID` (FK) | Client (Référence `profiles.id`) |
| `total_amount` | `DECIMAL` | Montant total payé |
| `order_status` | `TEXT` | Statut (`pending`, `confirmed`, `shipped`, `delivered`, `cancelled`) |
| `customer_name` | `TEXT` | Nom pour la livraison |
| `customer_email` | `TEXT` | Email de contact pour la commande |
| `customer_address`| `TEXT` | Adresse de livraison |
| `customer_phone` | `TEXT` | Numéro de téléphone |
| `created_at` | `TIMESTAMPTZ` | Date de la commande |
| `updated_at` | `TIMESTAMPTZ` | Date de mise à jour du statut |

---

### 6. `order_items`
Détail des articles contenus dans chaque commande (capture le prix au moment de l'achat).

| Attribut | Type | Description |
| :--- | :--- | :--- |
| `id` | `UUID` (PK) | Identifiant unique de la ligne |
| `order_id` | `UUID` (FK) | Commande parente (Référence `orders.id`) |
| `product_id` | `UUID` (FK) | Produit acheté (Référence `products.id`) |
| `quantity` | `INTEGER` | Quantité achetée |
| `price_at_purchase`| `DECIMAL`| Prix unitaire au moment de l'achat |
| `created_at` | `TIMESTAMPTZ` | Date de création |

---

## 🔐 Sécurité (Row Level Security)

Toutes les tables sont protégées par des politiques RLS :
- **profiles** : Un utilisateur ne peut voir et modifier que son propre profil.
- **products** : Tout le monde peut voir les produits actifs. Modification réservée aux admins.
- **cart_items** : Isolation par utilisateur (`user_id = auth.uid()`).
- **wishlist** : Isolation par utilisateur (`user_id = auth.uid()`).
- **orders** : Les utilisateurs ne voient que leurs propres commandes.
- **order_items** : Accessible seulement si l'utilisateur possède la commande parente.

---

*Dernière mise à jour : 27 Mars 2026*
