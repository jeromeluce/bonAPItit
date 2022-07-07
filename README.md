# bon-API-tit

## Résumé

bonAPItit permet d'organiser des repas en ville satisfaisant le plus grand nombre de personnes ! Particulièrement adapté aux repas entre collègues, bonAPItit vous trouve les meilleurs choix près de votre lieu de travail. 

Organisez un groupe, donnez le code aux participants, et laissez bonAPItit vous conseiller !

## Fonctionnalités prévues

Un utilisateur créé un event sur l'API. Il passe les informations suivantes :
+ Le nom de son événement
+ Une addresse de départ
+ Une distance maximale en km

L'API lui retourne alors, en cas de succès, les informations suivantes :
+ Un lien permettant de vérifier la géolocalisation et le rayon choisi 
+ Un code utilisateurs à six caractères
+ Son code administrateur à douze caractères

Le code utilisateurs permet aux autres participants de retrouver l'événement et d'entrer leurs préférences (budget, type de nourriture, allergies).

Le code administrateur, lui, permet de modifier les informations de l'événement (localisation, nom, distance max).

Les autres utilisateurs eux doivent donner à l'API les infos suivantes :
+ Leur nom
+ Leur email 
+ Une string optionnelle d'allergies
+ Le code utilisateurs

Ils reçoivent alors :
+ un code adminuser permettant de changer les informations à la volée.
+ une liste de types de restaurants disponibles 

Sans action de leur part, on suppose qu'ils sont ouverts à tout. Mais un endpoint permet de choisir des types, soit par choix, soit par élimination. 

Un endpoint pour lister les types qu'on veut choisir, un endpoint pour lister les types qu'on veut exclure. 


Un endpoint permet au créateur de récupérer une liste classée de restaurants correspondant aux attentes des autres participants. Le créateur peut passer trois valeurs optionnelles :
+ Le nombre de restaurants à afficher (par défaut, on en retourne jusqu'à 10)
+ L'heure du repas (par défaut, on suppose un service du midi pour toute requête réalisée avant 14H, service du soir pour toute requête réalisée après 14H)
+ J'ai de la chance : par défaut false, mais à true renvoie un restaurant au hasard parmis un nombre restaurants passé plus haut (qui devient alors un facteur risque)

Le backend se charge d'envoyer la liste des restaurants correspondant au créateur avec, pour chaque restaurant :
+ Pourcentage d'adéquation basé sur les choix des utilisateurs (en str, permettant d'avoir une réponse type "non applicable" si aucun utilisateur n'a émis de préférence)
+ Une note issue d'un site de reviews
+ Nom
+ Type de restaurant
+ Localisation
+ Distance depuis le lieu de travail

De plus, le créateur reçoit aussi :
+ Nombre final de participants
+ Liste des allergies

Le classement des restaurants se fait comme suit :
+ Un agrégat des préférences utilisateurs et notes d'internet, en privilégiant légèrement les notes d'internet
+ Si aucune préférence, le classement se fait sur les notes d'internet
+ En cas de notes similaires, le classement va privilégier la proximité géographique du lieu d'origine

Le créateur de l'événement peut retrouver les codes d'accès des participants en cas d'oubli. De plus, il peut supprimer des participants si nécessaire.