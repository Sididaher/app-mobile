# 🧪 Exemples de Requêtes Supabase - ShopHub

Ce document contient des requêtes SQL que vous pouvez exécuter dans Supabase pour tester, explorer et gérer vos données.

---

## 📌 REQUÊTES DE BASE

### Voir tous les utilisateurs

```sql
SELECT * FROM profiles;
```

### Voir tous les produits

```sql
SELECT * FROM products;
```

### Voir le panier d'un utilisateur

```sql
SELECT 
  ci.*,
  p.name,
  p.price
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.user_id = 'USER_ID_HERE'
ORDER BY ci.added_at DESC;
```

### Voir toutes les commandes

```sql
SELECT * FROM orders ORDER BY created_at DESC;
```

---

## 🔍 REQUÊTES DE RECHERCHE

### Trouver les produits par catégorie

```sql
SELECT * FROM products 
WHERE category = 'Vêtements' AND is_active = TRUE;
```

### Chercher un produit par nom

```sql
SELECT * FROM products 
WHERE name ILIKE '%T-Shirt%' AND is_active = TRUE;
```

### Trouver les produits en rupture de stock

```sql
SELECT * FROM products 
WHERE stock = 0 AND is_active = TRUE;
```

### Avoir tous les produits avec prix > 50€

```sql
SELECT * FROM products 
WHERE price > 50 AND is_active = TRUE
ORDER BY price ASC;
```

---

## 📊 STATISTIQUES

### Nombre total de produits

```sql
SELECT COUNT(*) as total_products FROM products WHERE is_active = TRUE;
```

### Nombre total d'utilisateurs

```sql
SELECT COUNT(*) as total_users FROM profiles;
```

### Nombre total de commandes

```sql
SELECT COUNT(*) as total_orders FROM orders;
```

### Chiffre d'affaires total

```sql
SELECT SUM(total_amount) as total_revenue FROM orders WHERE order_status != 'cancelled';
```

### Chiffre d'affaires par mois

```sql
SELECT 
  DATE_TRUNC('month', created_at) as month,
  COUNT(*) as order_count,
  SUM(total_amount) as revenue
FROM orders
WHERE order_status != 'cancelled'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month DESC;
```

### Produit le plus vendu

```sql
SELECT 
  p.name,
  p.category,
  COUNT(oi.id) as times_sold,
  SUM(oi.quantity) as total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.id, p.name, p.category
ORDER BY times_sold DESC
LIMIT 1;
```

### Catégorie la plus populaire

```sql
SELECT 
  p.category,
  COUNT(oi.id) as times_sold,
  SUM(oi.quantity) as total_quantity_sold
FROM order_items oi
JOIN products p ON oi.product_id = p.id
GROUP BY p.category
ORDER BY times_sold DESC;
```

---

## 👤 REQUÊTES UTILISATEURS

### Voir tous les utilisateurs avec leur nombre de commandes

```sql
SELECT 
  p.id,
  p.email,
  p.full_name,
  COUNT(o.id) as order_count
FROM profiles p
LEFT JOIN orders o ON p.id = o.user_id
GROUP BY p.id
ORDER BY order_count DESC;
```

### Trouver les utilisateurs les plus actifs

```sql
SELECT 
  p.email,
  COUNT(o.id) as orders,
  SUM(o.total_amount) as total_spent
FROM profiles p
LEFT JOIN orders o ON p.id = o.user_id
GROUP BY p.id, p.email
ORDER BY total_spent DESC
LIMIT 10;
```

### Voir le profil d'un utilisateur spécifique

```sql
SELECT * FROM profiles WHERE email = 'jean@example.com';
```

---

## 🛒 REQUÊTES PANIER

### Voir le panier d'un utilisateur

```sql
SELECT 
  ci.id,
  ci.quantity,
  p.name,
  p.price,
  (ci.quantity * p.price) as subtotal
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.user_id = 'USER_ID_HERE'
ORDER BY ci.added_at;
```

### Calculer le total du panier d'un utilisateur

```sql
SELECT 
  SUM(ci.quantity * p.price) as cart_total,
  COUNT(ci.id) as item_count
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.user_id = 'USER_ID_HERE';
```

### Trouver les paniers abandonnés (> 7 jours)

```sql
SELECT 
  ci.user_id,
  p.email,
  COUNT(ci.id) as items_in_cart,
  SUM(ci.quantity * pr.price) as cart_value,
  MAX(ci.added_at) as last_updated
FROM cart_items ci
JOIN profiles p ON ci.user_id = p.id
JOIN products pr ON ci.product_id = pr.id
WHERE ci.added_at < NOW() - INTERVAL '7 days'
GROUP BY ci.user_id, p.email;
```

---

## 📦 REQUÊTES COMMANDES

### Voir toutes les commandes avec détails

```sql
SELECT 
  o.id,
  o.created_at,
  p.email,
  o.customer_name,
  o.total_amount,
  o.order_status
FROM orders o
JOIN profiles p ON o.user_id = p.id
ORDER BY o.created_at DESC;
```

### Voir les détails d'une commande spécifique

```sql
SELECT 
  o.id as order_id,
  o.created_at,
  o.total_amount,
  o.order_status,
  p.name as product_name,
  oi.quantity,
  oi.price_at_purchase
FROM orders o
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE o.id = 'ORDER_ID_HERE';
```

### Les commandes d'un utilisateur

```sql
SELECT 
  id,
  created_at,
  total_amount,
  order_status,
  customer_name
FROM orders
WHERE user_id = 'USER_ID_HERE'
ORDER BY created_at DESC;
```

### Voir les commandes en attente (pending)

```sql
SELECT * FROM orders 
WHERE order_status = 'pending'
ORDER BY created_at ASC;
```

### Voir les commandes livrées

```sql
SELECT * FROM orders 
WHERE order_status = 'delivered'
ORDER BY created_at DESC;
```

### Temps moyen de traitement d'une commande

```sql
SELECT 
  AVG(EXTRACT(DAY FROM updated_at - created_at)) as avg_days_to_process
FROM orders
WHERE order_status IN ('delivered', 'shipped');
```

---

## ✏️ REQUÊTES DE MISE À JOUR

### Changer le statut d'une commande

```sql
UPDATE orders 
SET order_status = 'shipped', updated_at = NOW()
WHERE id = 'ORDER_ID_HERE';
```

### Mettre à jour un produit

```sql
UPDATE products
SET 
  name = 'Nouveau Nom',
  price = 49.99,
  stock = 100,
  updated_at = NOW()
WHERE id = 'PRODUCT_ID_HERE';
```

### Activer/Désactiver un produit

```sql
UPDATE products
SET is_active = FALSE, updated_at = NOW()
WHERE id = 'PRODUCT_ID_HERE';
```

### Réapprovisionner un produit

```sql
UPDATE products
SET stock = stock + 50, updated_at = NOW()
WHERE category = 'Vêtements';
```

### Mettre à jour le profil utilisateur

```sql
UPDATE profiles
SET 
  full_name = 'Jean Dupont',
  updated_at = NOW()
WHERE id = 'USER_ID_HERE';
```

---

## 🗑️ REQUÊTES DE SUPPRESSION

### Supprimer les paniers vides

```sql
DELETE FROM cart_items
WHERE quantity = 0;
```

### Supprimer les commandes annulées (> 30 jours)

```sql
DELETE FROM orders
WHERE order_status = 'cancelled' 
  AND created_at < NOW() - INTERVAL '30 days';
```

### Vider le panier d'un utilisateur

```sql
DELETE FROM cart_items
WHERE user_id = 'USER_ID_HERE';
```

---

## 🔧 REQUÊTES DE MAINTENANCE

### Voir les indices existants

```sql
SELECT * FROM pg_indexes 
WHERE schemaname = 'public';
```

### Vérifier les contraintes

```sql
SELECT * FROM information_schema.table_constraints
WHERE table_schema = 'public';
```

### Voir la taille des tables

```sql
SELECT 
  schemaname,
  tablename,
  pg_size_pretty(pg_total_relation_size(schemaname||'.'||tablename)) AS size
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY pg_total_relation_size(schemaname||'.'||tablename) DESC;
```

### Nettoyer les données obsolètes

```sql
-- Supprimer les commandes non confirmées > 24h
DELETE FROM orders
WHERE order_status = 'pending' 
  AND created_at < NOW() - INTERVAL '24 hours';
```

---

## 📈 REQUÊTES AVANCÉES

### Vue complète d'une commande avec tous les détails

```sql
SELECT 
  o.id as order_id,
  o.created_at,
  o.updated_at,
  o.order_status,
  p.email,
  p.full_name as profile_name,
  o.customer_name,
  o.customer_email,
  o.customer_address,
  o.customer_phone,
  o.total_amount,
  GROUP_CONCAT(pr.name, ', ') as products,
  COUNT(oi.id) as item_count,
  SUM(oi.quantity) as total_quantity
FROM orders o
JOIN profiles p ON o.user_id = p.id
LEFT JOIN order_items oi ON o.id = oi.order_id
LEFT JOIN products pr ON oi.product_id = pr.id
WHERE o.id = 'ORDER_ID_HERE'
GROUP BY o.id, p.id;
```

### Panier d'un utilisateur avec prix calculés

```sql
SELECT 
  p.id,
  p.name,
  p.category,
  p.price,
  ci.quantity,
  (p.price * ci.quantity) as line_total,
  SUM(p.price * ci.quantity) OVER () as cart_total
FROM cart_items ci
JOIN products p ON ci.product_id = p.id
WHERE ci.user_id = 'USER_ID_HERE'
ORDER BY ci.added_at DESC;
```

---

## 🧪 REQUÊTES DE TEST

### Insérer un produit de test

```sql
INSERT INTO products (name, description, price, category, image_url, stock, is_active)
VALUES (
  'Produit Test',
  'Description du produit de test',
  99.99,
  'Test',
  'https://via.placeholder.com/300x300?text=Test',
  10,
  TRUE
);
```

### Créer une commande de test

```sql
INSERT INTO orders (user_id, total_amount, order_status, customer_name, customer_email, customer_address, customer_phone)
SELECT 
  profiles.id,
  150.50,
  'pending',
  profiles.full_name,
  profiles.email,
  '123 Rue de Test',
  '0612345678'
FROM profiles
LIMIT 1;
```

---

## 💡 CONSEILS

1. ✅ Toujours vérifier vos requêtes en test avant production
2. ✅ Utiliser des transactions pour les opérations critiques
3. ✅ Monitorer les requêtes lentes
4. ✅ Créer des indices sur les colonnes souvent filtrées
5. ✅ Garder les backups à jour
6. ✅ Tester le RLS pour la sécurité

---

## 🚀 Commandes Utiles

**Voir les connexions actives :**
```sql
SELECT * FROM pg_stat_activity;
```

**Voir les modifications récentes (Audit) :**
```sql
-- Nécessite une table audit (future amélioration)
```

**Exécuter un VACUUM (optimisation) :**
```sql
VACUUM ANALYZE;
```

---

**Vous pouvez maintenant explorer et gérer votre base de données Shophub! 🎉**
