import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.operations.tsp";
import "./einnsyn.web.operations.tsp";
import "./einnsyn.exceptions.tsp";

using TypeSpec.OpenAPI;
using TypeSpec.Http;

@service(#{ title: "eInnsyn" })
@info(#{ version: "1.0" })
@useAuth(ApiKeyAuth<ApiKeyLocation.header, "API-KEY">)
namespace EInnsyn;

using EInnsyn;
