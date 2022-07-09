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
L'API récupère via Google Places jusqu'à 20 restaurants les plus pertinents (popularité, note) présents dans le radius donné.

Le code utilisateurs permet à d'autres utilisateurs de s'inscrire à l'événement.

Pour ce faire, ils donnent à l'API leur nom (name) et le code d'inscription (registration_code).

Ces utilisateurs peuvent renseigner une liste factultative d'allergies(allergies) pour en informer l'organisateur, soit à leur inscription à l'évenement, soit plus tard.

L'API leur retourne alors, en cas de succès, les informations suivantes :
+ Leur nom (name)
+ Leurs allergies (allergies) ou null si vide
+ Leur code (member_code) permettant de modifier leurs infos ou d'upvote/downvote des restaurants


Tout utilisateur peut à n'importe quel moment récupérer la liste des restaurants actuellement proposés. Ils sont uniquement classés par pertinence (selon l'API Google Places).

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
