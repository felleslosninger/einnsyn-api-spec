# <img src="https://einnsyn.no/8ebf89f8e40d3eb75183.svg" width="180px" alt="eInnsyn"/>

This repository contains the API specification for [eInnsyn](https://einnsyn.no)'s API. The API is written in [TypeSpec](https://typespec.io), and the generated OpenAPI document is available at [openapi/einnsyn.openapi.yml](openapi/einnsyn.openapi.yml).

The main files in the [typespec](typespec)-folder are:

- [einnsyn.tsp](typespec/einnsyn.tsp): Entry point for the API, including service metadata and authentication.
- [einnsyn.exceptions.tsp](typespec/einnsyn.exceptions.tsp): Shared exception and error response definitions.
- [einnsyn.arkiv.models.tsp](typespec/einnsyn.arkiv.models.tsp): Model definition for archive data, mostly Noark 5 with some extensions for meetings.
- [einnsyn.arkiv.operations.tsp](typespec/einnsyn.arkiv.operations.tsp): Endpoints for archive models.
- [einnsyn.queryparameters.tsp](typespec/einnsyn.queryparameters.tsp): Base models for query parameters.
- [einnsyn.responses.tsp](typespec/einnsyn.responses.tsp): Models for API responses.
- [einnsyn.web.models.tsp](typespec/einnsyn.web.models.tsp): Models for entities that are mainly used for the eInnsyn website, not related to archive data.
- [einnsyn.web.operations.tsp](typespec/einnsyn.web.operations.tsp): Endpoints for web models.

## Authentication

The eInnsyn API uses API keys to authenticate requests. To send an authenticated request, include the API key in the `API-KEY` header:

```sh
curl -H "API-KEY: <api-key>" https://api.einnsyn.no
```

## General endpoint structure

Most routable resources expose standard CRUD endpoints:

- `GET /{entityName}`: Get a paginated list of objects
- `GET /{entityName}/{id}`: Get an object
- `PATCH /{entityName}/{id}`: Update an object
- `DELETE /{entityName}/{id}`: Delete an object

Resources that do not require a parent object can usually be added directly at the root level using `POST /{entityName}`. Resources that require a parent are added through the parent resource, for example `POST /arkiv/{id}/arkivdel`.

The API also includes task-specific endpoints such as `/search`, `/statistics`, and `/me`.

## IDs

All objects in eInnsyn get an auto-generated `eInnsynId`. An `eInnsynId` is a Base32-encoded UUID with a prefix that indicates the type of resource. In the API specification, each entity has an extension annotation describing its ID prefix.

Example annotation for the Journalpost entity: `@extension("x-idPrefix", "jp")`.

Example journalpost ID: `jp_01jh532p3ve6haq7n53xgpqayh`

In addition, all Noark5 objects must have a globally unique systemId assigned by the publisher. This identifier can be used interchangeably with the eInnsynId in the API.

## Expanding responses

We use a concept called "expandable fields", inspired by Stripe's API ([Expanding Responses](https://docs.stripe.com/api/expanding_objects)). Throughout the API, references to entity objects are either an ID or the expanded object. On endpoints that support `expand`, nested objects in a `GET` response are sent as IDs by default. If you need nested objects, you can use the `expand` query parameter:

### Default expansion:

```sh
curl -H "API-KEY: <api-key>" https://api.einnsyn.no/saksmappe/sm_01jh50h5brf7wrbwga8xd0rwdy
{
  "entity": "Saksmappe",
  "id": "sm_01jh532p0jfdh8j3evmpgk4atx",
  ...
  "journalpost": [
    "jp_01jh532p3ve6haq7n53xgpqayh"
  ]
}
```

### Expand `journalpost`:

```sh
curl ... https://api.einnsyn.no/saksmappe/sm_01jh50h5brf7wrbwga8xd0rwdy?expand=journalpost
{
  "entity": "Saksmappe",
  "id": "sm_01jh532p0jfdh8j3evmpgk4atx",
  ...
  "journalpost": [{
    "entity": "Journalpost",
    "id": "jp_01jh532p3ve6haq7n53xgpqayh",
    ...
    "korrespondansepart": [
      "kp_01jh532p50epvvcjfv8xrzzwp5",
      "kp_01jh532p6qfhxrz1w9fdw4jjrh"
    ]
  }]
}
```

### Expand `journalpost.korrespondansepart`:

```sh
curl ... https://api.einnsyn.no/saksmappe/sm_01jh50h5brf7wrbwga8xd0rwdy?expand=journalpost.korrespondansepart
{
  "entity": "Saksmappe",
  "id": "sm_01jh532p0jfdh8j3evmpgk4atx",
  ...
  "journalpost": [{
    "entity": "Journalpost",
    "id": "jp_01jh532p3ve6haq7n53xgpqayh",
    ...
    "korrespondansepart": [{
      "entity": "Korrespondansepart",
      "id": "kp_01jh532p50epvvcjfv8xrzzwp5",
      ...
    },
    {
      "entity": "Korrespondansepart",
      "id": "kp_01jh532p6qfhxrz1w9fdw4jjrh",
      ...
    }]
  }]
}
```

## Client libraries

- Java SDK: [felleslosninger/einnsyn-sdk-java](https://github.com/felleslosninger/einnsyn-sdk-java)
- TypeScript SDK: [felleslosninger/einnsyn-sdk-typescript](https://github.com/felleslosninger/einnsyn-sdk-typescript)
