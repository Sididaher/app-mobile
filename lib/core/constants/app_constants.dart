class AppConstants {
  // Ordre status
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  // Messages
  static const String errorFetchingProducts = 'Erreur lors du chargement des produits';
  static const String errorFetchingCart = 'Erreur lors du chargement du panier';
  static const String errorCreatingOrder = 'Erreur lors de la création de la commande';
  static const String successOrderCreated = 'Commande créée avec succès';
  static const String errorAddingToCart = 'Erreur lors de l\'ajout au panier';
  static const String errorAuthentication = 'Erreur d\'authentification';
}
