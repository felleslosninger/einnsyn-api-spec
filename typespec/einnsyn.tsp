import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.arkiv.operations.tsp";
import "./einnsyn.web.operations.tsp";

using TypeSpec.OpenAPI;
using TypeSpec.Http;

@service({
  title: "eInnsyn",
})
@info({
  version: "1.0",
})
@useAuth(ApiKeyAuth<ApiKeyLocation.header, "X-EIN-API-KEY">)
namespace EInnsyn;

using EInnsyn;
