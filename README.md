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
            "name": string contenant le nom du restaurant (ex: "Le truck by Les Temps Gourmands"),
            "address": string human readable de l'adresse (ex: "5818F Kerverret, Plomeur"),
            "google_rating": float à une décimale maximum correspondant à l'aggrégat des notes laissées sur google reviews (ex: 5.0),
            "distance_in_km": float à trois décimales maximum montrant en kilomètres et à vol d'oiseau la distance entre le point d'origine du groupe et le restaurant (ex: 5.468)
        }
    ]
    
}
```
Tout utilisateur peut, pour chaque restaurant de la liste, émettre un vote positif(upvote) ou négatif(downvote). Il ne connait pas les votes des autres, uniquement le créateur du groupe peut obtenir cette information. 

Le code administrateur, lui, permet de modifier les informations de l'événement (adresse, nom, radius).

En cas de changement d'adresse ou de radius, un background job vient remettre la liste à jour.

Les restaurants qui ne se trouvent plus dans la liste après ces changements sont néanmoins gardés en DB pour garantir la permanence des votes émis.

Un endpoint permet au créateur de récupérer une liste classée de restaurants correspondant aux attentes des autres participants (en prenant en compte leurs votes, mais aussi la note donnée par les reviews Google, une simple somme des deux sert au classement)

+ Nom
+ Distance depuis le lieu de travail (à vol d'oiseau)
+ Score donné par les upvotes/downvotes des utilisateurs (cached_weighted_score)
+ Note Google Reviews

De plus, le créateur reçoit aussi :
+ Nombre total de membres pour son événement
+ Liste des allergies, par personne ayant renseigné une liste d'allergies
