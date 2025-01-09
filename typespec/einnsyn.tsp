import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.arkiv.operations.tsp";
import "./einnsyn.web.operations.tsp";

using TypeSpec.OpenAPI;

@service({
  title: "eInnsyn",
})
@info({
  version: "1.0",
})
namespace EInnsyn;

using EInnsyn;
