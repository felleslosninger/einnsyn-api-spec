# <img src="https://einnsyn.no/8ebf89f8e40d3eb75183.svg" width="180px" alt="eInnsyn"/>

This repository contains the API specification for [eInnsyn](https://einnsyn.no)'s API. The API is written in [TypeSpec](https://typespec.io).

## Authentication

The eInnsyn API uses API keys to authenticate requests. The keys are long-lived, and should be handled carefully. All API keys are prefixed with `secret_`.

To send an authenticated request, the API key should be sent in the `X-EIN-API-KEY` header:

```
curl -H "X-EIN-API-KEY: secret_..." https://api.einnsyn.no
```

## IDs

All objects in eInnsyn will get an auto-generated `eInnsynId`. An eInnsynId is a Base32 encoded UUID, with a prefix to indicate the type of resource. In the API specification, all entities has an extension annotation describing it's ID prefix.

Example annotation for the Journalpost entity: `@extension("x-idPrefix", "jp")`.

Example journalpost ID: `jp_01jh532p3ve6haq7n53xgpqayh`

## Expanding responses

We use a concept called "expandable fields", inspired by Stripe's API ([Expanding Responses](https://docs.stripe.com/api/expanding_objects)). Throughout the API, all references to entity objects are either an ID, or the actual object. By default, all nested objects in a `GET` response are sent as an ID. For `POST` and `PATCH` requests, all new objects are returned. If you need to access to nested objects, you can use the `expand` query parameter:

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

```

curl -H "X-EIN-API-KEY: secret\_..." https://api.einnsyn.no/saksmappe/sm_01jh50h5brf7wrbwga8xd0rwdy?expand=journalpost
{
"entity": "Saksmappe",
"id": "sm_01jh532p0jfdh8j3evmpgk4atx",
...
"journalpost": [
{
"entity": "Journalpost",
"id": "jp_01jh532p3ve6haq7n53xgpqayh",
...
"korrespondansepart": [
"kp_01jh532p50epvvcjfv8xrzzwp5",
"kp_01jh532p6qfhxrz1w9fdw4jjrh"
]
}
]
}

```

```

curl -H "X-EIN-API-KEY: secret\_..." https://api.einnsyn.no/saksmappe/sm_01jh50h5brf7wrbwga8xd0rwdy?expand=journalpost.korrespondansepart
{
"entity": "Saksmappe",
"id": "sm_01jh532p0jfdh8j3evmpgk4atx",
...
"journalpost": [
{
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
}
]
}

```

## Client libraries

Client libraries for Java and TypeScript are in the works. We're also considering a .NET client library.

```

```
