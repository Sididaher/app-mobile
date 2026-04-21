# ❓ FAQ - ShopHub Flutter + Supabase

Réponses aux questions les plus fréquemment posées.

---

## 🎯 ARCHITECTURE & DESIGN

### Q: Pourquoi cette architecture (Services/Models/Screens)?
**A:** C'est l'architecture **standard professionnelle** Flutter:
- **Séparation des préoccupations:** UI débranché de la logique
- **Testabilité:** Services peuvent être mockés
- **Scalabilité:** Ajouter features sans duplication
- **Maintenabilité:** Changements localisés

### Q: Puis-je utiliser Riverpod/Provider au lieu de setState?
**A:** **Oui absolument!** Voir [EVOLUTION.md](EVOLUTION.md) Phase 1. Les services restent exactement pareilles, seul le "state management" change dans les screens.

### Q: Pourquoi pas de GetX, BLoC, ou autre solution?
**A:** Pour le démarrage:
- `setState` est simple et contrôlable
- Pas de dépendance externe pour débuter
- Upgrade facile vers Riverpod/Provider plus tard
- Vous comprenez ce qui se passe

### Q: Le code est trop simple pour production?
**A:** Non, c'est précisément visé:
- ✅ Error handling complet
- ✅ Loading/Empty states
- ✅ Validation données
- ✅ RLS security
- ✅ Scalable patterns
- ❌ Pas de sur-complexité inutile

---

## 🔐 AUTHENTIFICATION

### Q: Comment reset password?
**A:** Non implémenté (Phase 2). Pour tester maintenant:
1. Aller Supabase Dashboard → Auth
2. Créer nouveau user manuellement
3. Ou modifier directement la table

### Q: Puis-je accepter login avec Google/GitHub?
**A:** **Oui**, c'est facilement intégrable. Voir [EVOLUTION.md](EVOLUTION.md) Phase 2 - "Social Login".

### Q: Session persiste après app close?
**A:** **Oui**, Supabase gère ça automatiquement. Splash screen vérifie et route correctement.

### Q: Puis-je avoir multi-device login?
**A:** **Oui**, par défaut Supabase supporté. Un user = une session à la fois (sécurité). Configurable en settings Supabase.

---

## 💳 PAIEMENTS & COMMANDES

### Q: Comment ajouter Stripe/PayPal?
**A:** Voir [EVOLUTION.md](EVOLUTION.md) Phase 4. Étapes:
1. Créer compte Stripe
2. Installer `flutter_stripe package`
3. Ajouter `PaymentService` dans `lib/services/`
4. Modifier `CheckoutScreen` pour afficher payment UI

### Q: Commande créée mais client repart sans payer?
**A:** Actuellement, tout ordre = créé immédiatement. Pour Phase 2:
1. Ajouter colonne `payment_status` dans table `orders`
2. Créer ordre avec `payment_status = pending`
3. Confirmer vrai paiement avant marquer `paid`
4. Webhook Stripe confirme paiement

### Q: Comment gérer les remboursements?
**A:** Ajouter colonnes `order_items`:
```sql
ALTER TABLE order_items ADD COLUMN refund_status VARCHAR(20) DEFAULT 'none';
ALTER TABLE order_items ADD COLUMN refund_reason TEXT;
```

### Q: Peut-on voir commandes en "attente paiement"?
**A:** Oui, modifier requête SQL dans `OrderService.getUserOrders()`:
```dart
.neq('order_status', 'cancelled')  // Exclure cancelled
.orderBy('created_at', ascending: false)
```

---

## 📸 IMAGES & MEDIA

### Q: Où stocker les images produits?
**A:** Actuellement: URL externe. Pour Phase 2 voir [EVOLUTION.md](EVOLUTION.md):
1. **Option 1:** Supabase Storage (recommandé)
2. **Option 2:** Cloudinary/Imgix
3. **Option 3:** AWS S3 + CloudFront

### Q: Comment ajouter plusieurs images par produit?
**A:** Créer table `product_images`:
```sql
CREATE TABLE product_images (
  id UUID PRIMARY KEY,
  product_id UUID REFERENCES products(id),
  image_url TEXT,
  sort_order INT,
  created_at TIMESTAMP
);
```

### Q: Images se chargent lentement?
**A:** Solutions:
1. Compresser images (max 200KB par image)
2. Utiliser CDN (CloudFront/Cloudflare)
3. Format WebP au lieu de JPG
4. Caching local avec Hive

---

## 🔍 RECHERCHE & FILTRAGE

### Q: Comment ajouter recherche avancée?
**A:** Voir [EVOLUTION.md](EVOLUTION.md) Phase 2. Exemple simple:
```dart
// Dans ProductService
Future<List<ProductModel>> searchAdvanced({
  String? name,
  String? category,
  double? minPrice,
  double? maxPrice,
}) async {
  var query = _supabase.from('products').select();
  
  if(name != null) query = query.ilike('name', '%$name%');
  if(category != null) query = query.eq('category', category);
  if(minPrice != null) query = query.gte('price', minPrice);
  if(maxPrice != null) query = query.lte('price', maxPrice);
  
  return (await query).map((p) => ProductModel.fromJson(p)).toList();
}
```

### Q: Puis-je filtrer par catégorie en temps réel?
**A:** **Oui**, modifier `HomeScreen`:
```dart
// Ajouter dropdown pour catégorie
DropdownButton(
  items: categories.map((c) => DropdownMenuItem(child: Text(c), value: c)).toList(),
  onChanged: (val) {
    setState(() => selectedCategory = val);
    _loadProducts();  // Recharger
  },
)
```

---

## 💾 BASE DE DONNÉES

### Q: Peut-on backup la base de données?
**A:** **Oui**, Supabase gère ça automatiquement (hourly). Aussi:
```bash
# Export SQL
pg_dump postgresql://user:password@host/db > backup.sql
```

### Q: Comment migrer vers une base existante?
**A:** Utiliser SQL migrations:
1. Exporter schema existant
2. Adapter les tables dans SETUP.md
3. Exécuter migration graduellement

### Q: Peut-on voir les queries Supabase tempo réelle?
**A:** **Oui**, dans Supabase Dashboard:
- **SQL Editor** → Execute queries
- **Logs** → Voir requêtes exécutées (Pro plan)

### Q: Comment optimiser queries lentes?
**A:** Étapes:
1. Ajouter indices sur colonnes filtrées
2. Limiter nombre de résultats (`.range(0, 20)`)
3. Ne pas charger tous les champs (`.select()` spécifique)
4. Utiliser View pour joins complexes

Exemple:
```dart
// ❌ Lent: tout charger
.select()

// ✅ Rapide: colonnes spécifiques + limite
.select('id, name, price')
.limit(20)
```

---

## 🎨 UI & DESIGN

### Q: Comment changer le thème (couleurs)?
**A:** Modifier `lib/core/theme/app_theme.dart`:
```dart
colorScheme: ColorScheme.fromSeed(
  seedColor: Colors.red,  // Changer color primaire
  brightness: Brightness.light,
)
```

### Q: Puis-je ajouter dark mode?
**A:** **Oui**, Ajouter dans `main.dart`:
```dart
home: Consumer(
  builder: (context, ref, child) {
    final isDark = ref.watch(themeProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
    );
  },
)
```

### Q: Comment faire responsive design?
**A:** Utiliser `MediaQuery`:
```dart
final width = MediaQuery.of(context).size.width;
final columns = width > 600 ? 3 : 2;

GridView.count(
  crossAxisCount: columns,
  children: products,
)
```

### Q: Puis-je utiliser composants custom?
**A:** **Absolument**, voir `lib/widgets/`. Créer nouveaux ou étendre.

---

## 🧪 TESTING

### Q: Comment tester les services?
**A:** Créer `test/services_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('CartService', () {
    test('addToCart ajoute article', () async {
      // Mock Supabase
      // Test addToCart logic
    });
  });
}
```

### Q: Peut-on tester auth?
**A:** **Oui**, mais c'est complexe. Recommandé après Phase 1.

### Q: Comment tester widgets?
**A:** `testWidgets` in `flutter_test`:
```dart
testWidgets('ProductCard affiche nom', (tester) async {
  await tester.pumpWidget(ProductCard(product: product));
  expect(find.text('T-Shirt'), findsOneWidget);
});
```

---

## 🚀 DÉPLOIEMENT

### Q: Comment deployer en production?
**A:** Voir [EVOLUTION.md](EVOLUTION.md) Phase 4. Résumé:
1. **Android:** Build APK/AAB via `flutter build apk`
2. **iOS:** Build via Xcode ou `flutter build ios`
3. **Web:** `flutter build web` → Deploy à Firebase Hosting
4. **Backend:** SQL schema en prod (Supabase)

### Q: Comment éviter les erreurs en prod?
**A:** 
1. ✅ Test complet sur device réel
2. ✅ Utiliser Supabase production (pas test)
3. ✅ Error tracking (Sentry, Firebase Crashlytics)
4. ✅ Monitoring logs
5. ✅ Load testing avant launch
6. ✅ Rollback plan

### Q: Peut-on avoir plusieurs versions de l'app?
**A:** **Oui**, utiliser Supabase Branches (Pro):
1. Branch `main` = production
2. Branch `dev` = développement
3. Branch `staging` = testing
4. Chaque branche indépendante

---

## 🐛 DEBUGGING

### Q: L'app crash, comment debug?
**A:** Steps:
1. Vérifier terminal logs: `flutter run` affiche stack trace
2. Ajouter `print()` statements
3. Utiliser Android Studio/Xcode debugger
4. Supabase Dashboard vérifier erreurs

### Q: Service retourne null?
**A:** Ajouter debug:
```dart
try {
  final product = await productService.getProductById(id);
  print('Product: $product');  // Voir si null
} catch(e) {
  print('Error: $e');
}
```

### Q: FutureBuilder toujours loading?
**A:** Vérifier:
1. Service a une Duration longue?
2. Y a-t-il une exception non catchée?
3. Supabase connection ok?

Ajouter timeout:
```dart
future: productService.getActiveProducts()
    .timeout(Duration(seconds: 10), 
      onTimeout: () => []),
```

---

## 📞 SUPPORT R & D

### Q: Où trouver plus d'info Supabase?
**A:** 
- [docs.supabase.com](https://docs.supabase.com)
- [Discord Supabase](https://discord.supabase.com)
- [GitHub Issues](https://github.com/supabase/supabase)

### Q: Où trouver ressources Flutter?
**A:**
- [flutter.dev](https://flutter.dev)
- [pub.dev](https://pub.dev) (packages)
- [Codelab Flutter](https://codelabs.developers.google.com/?product=flutter)
- [YouTube Flutter Officia](https://www.youtube.com/flutterdev)

### Q: Comment upgrader Supabase version?
**A:**
```bash
flutter pub upgrade supabase_flutter
# ou spécifique
flutter pub add supabase_flutter:^2.2.0
```

### Q: Puis-je contribuer évoluer cet projet?
**A:** **Oui!** Ideas:
1. Fork le repo
2. Créer une branche
3. Implémente feature
4. PR avec description

---

## 💡 TIPS & TRICKS

### Tip 1: Utiliser Supabase Schema Visualizer
```
Supabase Dashboard → SQL Editor → 
Cliquer icon "Schema Visualizer"
→ Voir toutes relations graphiquement
```

### Tip 2: Real-time subscriptions
Ajouter listener au panier:
```dart
_supabase
  .from('cart_items')
  .on(RealtimeListenTypes.all, callback: (payload) {
    // Panier update en temps réel!
  })
  .subscribe();
```

### Tip 3: Performance: Paginate results
```dart
// Charger par 20 articles à la fois
.range(0, 19)  // Articles 1-20
.range(20, 39) // Articles 21-40
```

### Tip 4: Utiliser Views pour requêtes complexes
```sql
-- Une seule fois
CREATE VIEW user_order_summary AS
SELECT user_id, COUNT(*) as order_count, 
       SUM(total_amount) as total_spent
FROM orders
GROUP BY user_id;

-- Puis en Dart ultra-rapide:
_supabase.from('user_order_summary').select()
```

### Tip 5: Gérer les erreurs Supabase
```dart
try {
  await authService.login(...);
} on AuthException catch(e) {
  // Auth-specific error
  print('Auth error: ${e.message}');
} on PostgrestException catch(e) {
  // Database error
  print('DB error: ${e.details}');
} catch(e) {
  // Generic error
  print('Unknown error: $e');
}
```

---

## 🔗 RESSOURCES

### Documentation
- [README_SUPABASE.md](README_SUPABASE.md) - Ref API
- [SETUP.md](SETUP.md) - Installation
- [EVOLUTION.md](EVOLUTION.md) - Features futures
- [SQL_EXEMPLES.md](SQL_EXEMPLES.md) - Query examples
- [QUICKSTART.md](QUICKSTART.md) - 15min démarrage

### Code
- `lib/services/` - Logique métier
- `lib/screens/` - UI/UX
- `lib/models/` - Data structures
- `lib/widgets/` - Composants réutilisables

---

## 🎉 Encore des questions?

Notre architecture est documentée à **100%**. Si vous ne trouvez pas la réponse:

1. ✅ Vérifier `README_SUPABASE.md` - Référence complète
2. ✅ Consulter `EVOLUTION.md` - Roadmap + explications
3. ✅ Lire les comments dans le code
4. ✅ Exécuter requêtes `SQL_EXEMPLES.md` pour tester

**Vous avez les outils pour explorer et comprendre entièrement!** 🚀

---

**Bonne chance avec ShopHub! Happy hacking! 💻🛍️**
