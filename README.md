# <img src="https://einnsyn.no/8ebf89f8e40d3eb75183.svg" width="180px" alt="eInnsyn"/>

This repository contains the API specification for [eInnsyn](https://einnsyn.no)'s API. The API is written in [TypeSpec](https://typespec.io), with an auto-generated OpenAPI version in the [openapi](openapi)-folder.

The [typespec](typespec)-folder contains the following files:

- [einnsyn.arkiv.models.tsp](typespec/einnsyn.arkiv.models.tsp): Model definition for archive data, mostly Noark 5 with some extensions for meetings.
- [einnsyn.arkiv.operations.tsp](typespec/einnsyn.arkiv.operations.tsp): Endpoints for archive models.
- [einnsyn.queryparameters.tsp](typespec/einnsyn.queryparameters.tsp): Base models for query parameters.
- [einnsyn.responses.tsp](typespec/einnsyn.responses.tsp): Models for API responses.
- [einnsyn.web.models.tsp](typespec/einnsyn.web.models.tsp): Models for entities that are mainly used for the eInnsyn website, not related to archive data.
- [einnsyn.web.operations.tsp](typespec/einnsyn.web.operations.tsp): Endpoints for web models.

## Authentication

The eInnsyn API uses API keys to authenticate requests. The keys are long-lived, and should be handled carefully. All API keys are prefixed with `secret_`.

To send an authenticated request, the API key should be sent in the `X-EIN-API-KEY` header:

```
curl -H "X-EIN-API-KEY: secret_..." https://api.einnsyn.no
```

## General endpoint structure

All entities has standard CRUD-endpoints:

- `POST /{entityName}`: Create object
- `GET /{entityName}`: Get a paginated list of objects
- `GET /{entityName}/{id}`: Get an object
- `PATCH /{entityName}/{id}`: Update an object
- `DELETE /{entityName}/{id}`: Delete an object

## IDs

All objects in eInnsyn will get an auto-generated `eInnsynId`. An eInnsynId is a Base32 encoded UUID, with a prefix to indicate the type of resource. In the API specification, all entities has an extension annotation describing it's ID prefix.

Example annotation for the Journalpost entity: `@extension("x-idPrefix", "jp")`.

Example journalpost ID: `jp_01jh532p3ve6haq7n53xgpqayh`

In addition, all Noark5 objects must have a globally unique systemId assigned by the publisher. This identifier can be used interchangeably with the eInnsynId in the API.

## Expanding responses

We use a concept called "expandable fields", inspired by Stripe's API ([Expanding Responses](https://docs.stripe.com/api/expanding_objects)). Throughout the API, all references to entity objects are either an ID, or the actual object. By default, all nested objects in a `GET` response are sent as an ID. For `POST` and `PATCH` requests, all new objects are returned. If you need to access nested objects, you can use the `expand` query parameter:

### Default expansion:

```
curl -H "X-EIN-API-KEY: secret\_..." https://api.einnsyn.no/saksmappe/sm_01jh50h5brf7wrbwga8xd0rwdy
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

```
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

```
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

Client libraries for Java and TypeScript are in the works. We're also considering a .NET client library.
