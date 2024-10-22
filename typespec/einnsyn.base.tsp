import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

using TypeSpec.Http;
using TypeSpec.OpenAPI;

@service({
  title: "eInnsyn",
})
@info({
  version: "1.0",
})
namespace eInnsyn;

alias EInnsynId = string;

@extension("x-resourceId", "Base")
model EInnsynBase {
  /**
   * The unique identifier for the resource. This is is assigned by the system when the resource is created.
   */
  @visibility("read") id: string;

  /**
   * A timestamp of when the resource was created. This field is updated automatically.
   */
  @visibility("read") created: utcDateTime;

  /**
   * A timestamp of when the resource was last updated. This field is updated automatically.
   */
  @visibility("read") updated: utcDateTime;

  /**
   * This field is only present if the resource has been deleted. If present, it will always be `true`.
   */
  @visibility("read") deleted?: boolean;

  /**
   * An external ID for the resource. This is similar to "systemId", but will be used for legacy IRIs that were used in earlier eInnsyn versions.
   */
  externalId?: string;
}

/**
 * eInnsyn Enhet
 */
@extension("x-resourceId", "Enhet")
@extension("x-idPrefix", "enh")
model Enhet extends EInnsynBase {
  @visibility("read") entity?: "Enhet";
  navn: string;
  navnNynorsk?: string;
  navnEngelsk?: string;
  navnSami?: string;
  @pattern("^[0-9]{9}$") orgnummer: string;
  enhetskode?: string;
  kontaktpunktAdresse?: string;
  @format("email") kontaktpunktEpost: string;
  kontaktpunktTelefon?: string;
  @format("email") innsynskravEpost: string;
  enhetstype:
    | "ADMINISTRATIVENHET"
    | "AVDELING"
    | "BYDEL"
    | "DUMMYENHET"
    | "FYLKE"
    | "KOMMUNE"
    | "ORGAN"
    | "SEKSJON"
    | "UTVALG"
    | "VIRKSOMHET";
  avsluttetDato?: plainDate;
  skjult?: boolean;
  eFormidling?: boolean;
  teknisk?: boolean;
  skalKonvertereId?: boolean;
  skalMottaKvittering?: boolean;
  visToppnode?: boolean;
  orderXmlVersjon?: integer;
  underenhet?: (EInnsynId | Enhet)[];
  handteresAv?: EInnsynId | Enhet;
  parent?: EInnsynId | Enhet;
}

@extension("x-resourceId", "ApiKey")
@extension("x-idPrefix", "key")
model ApiKey extends EInnsynBase {
  @visibility("read") entity?: "ApiKey";

  /**
   * A name for the API key. This can be used to identify the key, in case you have multiple keys for multiple systems.
   */
  name?: string;

  /**
   * The API key used to authenticate requests. This will only be shown once, and we will only store a hashed version.
   */
  secretKey?: string;

  /**
   * The Enhet that requests using this key will be associated with.
   */
  enhet?: string | Enhet;
}

/**
 * Result list
 */
model ResponseList<Object = EInnsynBase> {
  @statusCode _: 200;
  items: Object[];
  next?: string;
  previous?: string;
}

model ResponseGet<Object = EInnsynBase> {
  @statusCode _: 200;
  @body body: Object;
}

model ResponseAdd<Object = EInnsynBase> {
  @statusCode _: 201;
  @body body: Object;
}

model ResponseUpdate<Object = EInnsynBase> {
  @statusCode _: 200;
  @body body: Object;
}

model ResponseDelete<Object = EInnsynBase> {
  @statusCode _: 200;
  @body body: Object;
}

@error
model Error {
  @statusCode _: 400;
  @body body: {
    message: string;
  };
}

interface Routable<T, name extends valueof string = "_"> {
  @route("/{id}")
  @get
  @operationId("Get${name}")
  get(...GetParameters, @path id: EInnsynId): ResponseGet<T>;

  @route("/{id}")
  @put
  @operationId("Put${name}")
  update(@path id: EInnsynId, @body body: T): ResponseUpdate<T>;

  @route("/{id}")
  @delete
  @operationId("Delete${name}")
  delete(@path id: EInnsynId): ResponseDelete<T>;
}

interface GloballyRoutable<T, name extends valueof string = "_">
  extends Routable<T, name> {
  @route("/")
  @get
  @operationId("Get${name}List")
  list(...ListParameters): ResponseList<T>;

  @route("/")
  @post
  @operationId("Post${name}")
  add(@body body: T): ResponseAdd<T>;
}

model GetParameters {
  @query expand?: string[] = #[];
}

model ListParameters {
  /**
   * Specifies which fields in the response should be expanded.
   */
  @query expand?: string[];

  /**
   * A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 10.
   */
  @query limit?: integer = 25;

  /**
   * The sort order of the result set. The default is ascending.
   */
  @query sortOrder?: "asc" | "desc";

  /**
   * A cursor for use in pagination. StartingAfter is a resource ID that defines your place in the list.
   */
  @query startingAfter?: string;

  /**
   * A cursor for use in pagination. EndingBefore is a resource ID that defines your place in the list.
   */
  @query endingBefore?: string;

  /**
   * A list of resource IDs to be returned. If this parameter is used, the other parameters will be ignored.
   */
  @query ids?: string[];

  /**
   * A list of external IDs to be returned. If this parameter is used, the other parameters will be ignored.
   */
  @query externalIds?: string[];

  /**
   * The Journalenhet to filter the result set by.
   */
  @query journalenhet?: string;
}
