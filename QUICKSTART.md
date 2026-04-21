# 🚀 GUIDE DE DÉMARRAGE RAPIDE - ShopHub

**Durée estimée: 15 minutes** ⏱️

## ✅ ÉTAPE 0: Vérification

Assurez-vous d'avoir:
- ✅ Flutter 3.11+ installé
- ✅ Android Studio / Xcode (pour device ou emulator)
- ✅ Account Supabase (gratuit)
- ✅ Internet connection

---

## 📋 ÉTAPE 1: Créer un Project Supabase (5 min)

### 1.1 Aller sur Supabase
```
https://app.supabase.com
```

### 1.2 Créer nouveau project
1. Sign up / Log in
2. Cliquer **New Project**
3. Nom: `shophub`
4. Password: Générer strong password (noter quelque part!)
5. Region: Europe (close to you)
6. Cliquer **Create new project**

⏳ Attendre 2-3 minutes (le projet s'initialise)

### 1.3 Récupérer les credentials
1. Dans dashboard → **Settings** (gear icon)
2. Cliquer **API** dans menu gauche
3. Copier:
   - **Project URL** (ex: `https://xxxxxxxxxxxxxx.supabase.co`)
   - **anon public key** (longue clé qui commence par `eyJ...`)

> **Sauvegarder ces 2 valeurs!** Vous en aurez besoin à l'étape 2.

---

## 🛠️ ÉTAPE 2: Configurer Flutter (2 min)

### 2.1 Ouvrir le fichier config
Ouvrir dans votre éditeur:
```
lib/core/config/supabase_config.dart
```

### 2.2 Remplacer les placeholders
Trouver ces lignes:
```dart
const String SUPABASE_URL = 'YOUR_SUPABASE_URL_HERE';
const String SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY_HERE';
```

Remplacer par vos vraies valeurs. Exemple:
```dart
const String SUPABASE_URL = 'https://abcdefghij.supabase.co';
const String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

### 2.3 Sauvegarder le fichier
Ctrl+S (ou Cmd+S sur Mac)

---

## 🗄️ ÉTAPE 3: Créer la Base de Données (5 min)

### 3.1 Ouvrir Supabase SQL Editor
1. Retour dans dashboard Supabase
2. Menu gauche: **SQL Editor**
3. Cliquer le **+** pour nouveau query

### 3.2 Copier tout le SQL
1. Ouvrir [SETUP.md](SETUP.md) dans votre dossier
2. Copier **tout le contenu** entre `-- BEGIN SQL` et `-- END SQL`

### 3.3 Exécuter le SQL
1. Coller le SQL dans Supabase SQL Editor
2. Cliquer **RUN** (ou Ctrl+Enter)
3. ✅ Vérifier: `Query Executed OK` message

> **💡 Tip:** Les tables et les 6 produits de test sont maintenant créés!

### 3.4 Vérifier les tables (optionnel)
Menu gauche → **Table Editor** → Vous devez voir:
- ✅ `profiles`
- ✅ `products` (6 produits)
- ✅ `cart_items`
- ✅ `orders`
- ✅ `order_items`

---

## 📦 ÉTAPE 4: Installer les Dépendances (3 min)

### 4.1 Terminal dans le dossier projet
```bash
cd c:\Users\hp\Desktop\testFlutter\testflutter
```

### 4.2 Télécharger les dépendances
```bash
flutter pub get
```

Attendre que tout s'installe (~2-3 min)

---

## 🎮 ÉTAPE 5: Lancer l'App (1-2 min)

### 5.1 Choisir device
```bash
flutter devices
```

Vous verrez une liste. Choisir le device (ex: Android emulator, iPhone simulator, physical device)

### 5.2 Lancer l'app
```bash
flutter run
```

Ou pour web:
```bash
flutter run -d web
```

⏳ Attendre 30-60 sec (première compilation)

✅ L'app doit démarrer avec écran **Splash** pendant 2 sec, puis aller à **Login**

---

## 🧪 ÉTAPE 6: Tester l'App (3-4 min)

### 6.1 Créer un compte
1. Cliquer **Register**
2. Remplir:
   - Full Name: `Jean Test`
   - Email: `jean@test.com`
   - Password: `password123`
   - Confirm Password: `password123`
3. Cliquer **Register**

✅ Doit aller au **Home** (catalogue)

### 6.2 Voir les produits
- Vous devez voir **6 produits** en grille (T-Shirt, Jeans, Pull, etc.)
- Chaque carte affiche: image, nom, catégorie, prix

### 6.3 Ajouter au panier
1. Cliquer une carte produit
2. Voir les détails (image + description + stock)
3. Ajuster quantité (+ et -)
4. Cliquer **Add to Cart**

✅ Badge panier en haut doit montrer "1"

### 6.4 Voir le panier
1. Cliquer icône **panier** en AppBar
2. Voir l'article avec prix × quantité
3. Voir le **total** en bas

### 6.5 Passer une commande
1. Cliquer **Proceed to Checkout**
2. Remplir formulaire (nom, adresse, téléphone)
3. Cliquer **Place Order**

✅ Doit aller à **Orders** et afficher votre commande

### 6.6 Voir l'historique
- Dashboard affiche votre commande avec:
  - Status (pending/shipped/delivered)
  - Montant total
  - Date

---

## 🎉 VOUS AVEZ RÉUSSI!

Votre app ShopHub fonctionne complètement! 🎊

### Maintenant vous pouvez:
- ✅ Tester toutes les fonctionnalités
- ✅ Modifier les produits dans Supabase
- ✅ Ajouter plus de produits
- ✅ Comprendre comment ça marche
- ✅ Préparer Phase 2 (voir EVOLUTION.md)

---

## 🆘 TROUBLESHOOTING

### ❌ App crashes au démarrage
**Cause:** Supabase URL ou clé invalide
**Fix:** Triple-check `lib/core/config/supabase_config.dart` (pas d'espaces!)

### ❌ "Cannot register" error
**Cause:** Utilisateur existe déjà
**Fix:** Tenter avec email différent (ex: jean2@test.com)

### ❌ Produits ne s'affichent pas
**Cause:** SQL pas exécuté complètement
**Fix:** Retourner SETUP.md, re-copier et exécuter SQL entièrement

### ❌ Panier ne se met pas à jour
**Cause:** Rafraîchir page/coulisse bas
**Fix:** Faire FutureBuilder reconstruit (naviguer et revenir)

### ❌ "Permission denied" au checkout
**Cause:** RLS policies pas activées
**Fix:** Vérifier SETUP.md section "Enable RLS"

---

## 💡 PRO TIPS

1. **Développement rapide:**
   ```bash
   flutter run -d chrome  # Web testing très rapide
   ```

2. **Hot Reload** pendant développement:
   - Modifier le code
   - Sauvegarder (Ctrl+S)
   - Dans flutter terminal, appuyer **r** pour hot reload

3. **Voir logs Supabase:**
   - Supabase dashboard → **SQL Editor**
   - Vérifier **logs** si erreurs

4. **Tester RLS:**
   - Se connecter avec user différent
   - Vérifier que vous SEUL voyez vos commandes

---

## 📚 DOCUMENTATION COMPLÈTE

Consultez ces fichiers pour plus de détails:
- [README_SUPABASE.md](README_SUPABASE.md) - Référence API complète
- [SQL_EXEMPLES.md](SQL_EXEMPLES.md) - Requêtes pour tester base de données
- [EVOLUTION.md](EVOLUTION.md) - Features futures (Riverpod, Storage, Payments, etc.)
- [CHECKLIST_DELIVERABLES.md](CHECKLIST_DELIVERABLES.md) - Tout ce qui a été livré

---

## ✅ Checklist FINALE

- [ ] Supabase account créé
- [ ] Project URL copié
- [ ] Anon Key copié
- [ ] Config file rempli (supabase_config.dart)
- [ ] SQL exécuté dans Supabase
- [ ] `flutter pub get` lancé
- [ ] `flutter run` lancé
- [ ] Écran Login visible
- [ ] User registered
- [ ] Produits affichés
- [ ] Produit ajouté au panier
- [ ] Commande passée
- [ ] Historique commandes visible

**Si toutes les cases sont ✅, vous êtes ready! 🚀**

---

## 🎓 Prochaines Étapes

1. **Exploration:** Jouer avec l'app et Supabase
2. **Compréhension:** Lire `README_SUPABASE.md` pour architecture
3. **Évolution:** Consulter `EVOLUTION.md` pour Phase 2
4. **Testing:** Exécuter requêtes SQL_EXEMPLES.md pour apprendre
5. **Customisation:** Modifier couleurs, produits, formulaires

---

**Bienvenue à ShopHub! 🛍️ Happy coding! 💻**
