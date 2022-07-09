# bon-API-tit

## En quelques mots

bonAPItit permet d'organiser des repas en ville satisfaisant le plus grand nombre de personnes ! Particulièrement adapté aux repas entre collègues, bonAPItit vous trouve les meilleurs choix près de votre lieu de travail (ou autre !). 

Organisez un groupe, donnez le code aux participants, et laissez bonAPItit vous conseiller !


## Fonctionnalités et endpoints

Un utilisateur créé un groupe de repas sur l'API.

**POST /api/v1/groups**
```
Body {
    "name": string (ex: "Repas MVMS"), 
    "address": string human readable (ex: "28 rue de la paix Tourcoing"), 
    "radius": integer de 1000 à 50000, représentant le rayon jusqu'auquel l'API doit trouver des restaurants, en mètres (ex: 5000)
}
```

L'API en cas de succès répond avec les informations suivantes :
```
{
    "id": id du groupe,
    "name": nom du groupe tel que fourni par l'utilisateur,
    "address": adresse human readable telle que fournie par l'utilisateur,
    "latlng": coordonnées latitude/longitude géocodée pour l'adresse, en string (ex: "47.794762,-4.292968"),
    "address_visualization": string URL google maps permettant de rapidement vérifier la précision du geocoding (ex: "http://www.google.com/maps/place/47.794762,-4.292968"),
    "radius": rayon tel que fourni par l'utilisateur,
    "registration_code": string de six caractères hexadecimaux permettant à des utilisateurs de rejoindre le groupe (ex: "42ae84"),
    "admin_code": string de douze caractères (dont les six premiers sont le registration_code) permettant au créateur du groupe d'en modifier les informations et de récupérer la liste de restaurants complète (ex: "42ae8445f7f9")
}
```

L'API récupère ensuite via Google Places jusqu'à 20 restaurants les plus pertinents (popularité, note) présents dans le radius donné.

Le code utilisateurs permet à d'autres utilisateurs de s'inscrire à l'événement.

**POST /api/v1/members**
```
Body {
    "name": string contenant le nom du membre (ex: "Jean Marc Machintruc"),
    "registration_code": string de six caractères reçue par le créateur du groupe (ex: "42ae84"),
    "allergies": string optionnelle d'allergies (ex: "Couscous de chou-fleur")
}
```

L'API en cas de succès répond avec les informations suivantes :
```
{
    "name": information telle que fournie par l'utilisateur (ex: "Jean Marc Machintruc"),
    "allergies": information telle que fournie par l'utilisateur ou null (ex: "Couscous de chou-fleur"),
    "member_code": string de six caractères permettant à l'utilisateur d'émettre des votes (ex: "84d0fc"),
    "group_id": id du groupe, nécessaire pour récupérer la liste de restaurants provisoire.
}
```

Tout utilisateur peut à n'importe quel moment récupérer la liste des restaurants actuellement proposés. Ils sont uniquement classés par pertinence selon l'API Google Places.

**POST /api/v1/groups/:group_id/restaurants_list**
```
{
    "registration_code": string de six caractères reçue par le créateur du groupe (ex: "42ae84")
}
```

L'API en cas de succès répond avec les informations suivantes :
```
{
    "restaurants": array de maximum 20 restaurants [
        {
            "id" : id du restaurant, permettant le vote du membre (ex: 2)
            "name": string contenant le nom du restaurant (ex: "Le truck by Les Temps Gourmands"),
            "address": string human readable de l'adresse (ex: "5818F Kerverret, Plomeur"),
            "google_rating": float à une décimale maximum correspondant à l'aggrégat des notes laissées sur google reviews (ex: 5.0),
            "distance_in_km": float à trois décimales maximum montrant en kilomètres et à vol d'oiseau la distance entre le point d'origine du groupe et le restaurant (ex: 5.468)
        }
    ]
    
}
```

Tout utilisateur peut, pour chaque restaurant de la liste, émettre un vote positif(upvote) ou négatif(downvote). Il ne connait pas les votes des autres, uniquement le créateur du groupe peut obtenir cette information. 

**POST /api/v1/restaurants/:restaurant_id/upvote_restaurant**

**POST /api/v1/restaurants/:restaurant_id/downvote_restaurant**
```
{
    "member_code": string de six caractères obtenue à la création du membre (ex: "84d0fc")
}
```

L'API en cas de succès répond avec les informations suivantes :
```
{
    "vote_registered": string "Success",
    "restaurant": string contenant le nom du restaurant (ex: "O Resto Du Bourg")
}
```

Le créateur du groupe peut récupérer sa propre version de la liste de restaurants contenant des informations sur les membres et qui est classée selon un score qui est la somme du score google reviews et des votes des membres (+1 ou -1 par vote).

**POST /api/v1/groups/:group_id/owner_restaurants_list**
```

{
    "admin_code": string de douze caractères obtenue lors de la création du groupe (ex: "42ae8445f7f9")
}
```

L'API en cas de succès répond avec les informations suivantes :
```
{   
    "name": string correspondant au nom du groupe (ex: "Repas MVMS"),
    "address": string human readable de l'adresse (ex: "5818F Kerverret, Plomeur"),
    "radius": integer rappelant le rayon du groupe (ex: 45000),
    "members": integer représentant le nombre de membres ayant rejoint le groupe (ex: 67),
    "member_allergies" array contenant les informations d'allergies si remplies par les membres [
        {
            "name": string contenant le nom du membre ayant renseigné des allergies (ex: "Jean Marc"),
            "allergy": string contenant les allergies renseignées (ex: "Couscous de chou-fleur")
        }
    ]
    "restaurants": array de maximum 20 restaurants [
        {
            "name": string contenant le nom du restaurant (ex: "Le truck by Les Temps Gourmands"),
            "address": string human readable de l'adresse (ex: "5818F Kerverret, Plomeur"),
            "google_rating": float à une décimale maximum correspondant à l'aggrégat des notes laissées sur google reviews (ex: 5.0),
            "distance_in_km": float à trois décimales maximum montrant en kilomètres et à vol d'oiseau la distance entre le point d'origine du groupe et le restaurant (ex: 5.468),
            "cached_weighted_score": integer représentant la somme des upvotes/downvotes du restaurant par les membres du groupe (ex: -42)
        }
    ]
    
}
```

L'organisateur peut à tout moment changer les informations de son groupe.

**PATCH /api/v1/groups/:group_id**
```
Body {
    "admin_code": string de douze caractères nécessaire pour vérifier l'identité de l'organisateur (ex: "42ae8445f7f9"),
    "name": string (ex: "Repas MVMS"), 
    "address": string human readable (ex: "28 rue de la paix Tourcoing"), 
    "radius": integer de 1000 à 50000, représentant le rayon jusqu'auquel l'API doit trouver des restaurants, en mètres (ex: 5000)
}
```

Il est à noter que tout changement de la valeur *address* ou *radius* relance un background job allant chercher jusqu'à 20 nouveaux restaurants. Les restaurants qui ne sont plus dans le nouveau rayon de la potentielle nouvelle adresse ne seront plus montrés dans les listes, mais toujours gardés en base de donnée afin de garantir la permanence des votes effectués par les membres (dans le cas d'un futur changement de *radius* ou *address* faisant ressortir à nouveau des résultats présents précédemment).

## Accéder à cette API

L'API est actuellement hostée sur Heroku à l'adresse suivante : **https://young-cove-27686.herokuapp.com/api/v1/**

Elle sera très probablement mise hors service d'ici la fin du mois de Juillet 2022.
