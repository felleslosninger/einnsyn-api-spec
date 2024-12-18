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
namespace EInnsyn;

@format("id")
scalar eInnsynId<T = null> extends string;

alias ExpandableField<T> = eInnsynId<T> | T;
namespace Base {
  @extension("x-resourceId", "Base")
  model Base {
    /**
     * The unique identifier for the resource. This is is assigned by the system when the resource is created.
     */
    @visibility("read") id: eInnsynId<Base>;

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
}

namespace Enhet {
  /**
   * eInnsyn Enhet
   */
  @extension("x-resourceId", "Enhet")
  @extension("x-idPrefix", "enh")
  model Enhet extends Base.Base {
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
    @oneOf enhetstype:
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
    underenhet?: ExpandableField<Enhet>[];
    handteresAv?: ExpandableField<Enhet>;
    parent?: ExpandableField<Enhet>;
  }
}

namespace ApiKey {
  @extension("x-resourceId", "ApiKey")
  @extension("x-idPrefix", "key")
  model ApiKey extends Base.Base {
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
    enhet?: ExpandableField<Enhet.Enhet>;
  }
}

namespace Responses {
  model ListResponseBody<T extends Base.Base> {
    items: Array<T>;
    next?: url;
    previous?: url;
  }

  model ErrorResponseBody {
    status: string;
    message: string;
  }

  model ValidationErrorResponseBody extends ErrorResponseBody {
    fieldError: {
      fieldName: string;
      value?: string;
      message?: string;
    }[];
  }

  /**
   * Result list
   */
  model ListResponse<T extends Base.Base = Base.Base> {
    @statusCode _: 200;
    @body body: ListResponseBody<T>;
  }

  model OkResponse<T extends Base.Base = Base.Base> {
    @statusCode _: 200;
    @body body: T;
  }

  model AddResponse<T extends Base.Base = Base.Base> {
    @statusCode _: 201;
    @body body: T;
  }

  @error
  model ErrorResponse {
    @statusCode _: 400;
    @body body: ErrorResponseBody;
  }
}

interface Routable<T extends Base.Base> {
  /**
   * Get an object.
   * @param id The ID of the object.
   * @returns The object.
   */
  @route("/{id}")
  @get
  get(
    ...QueryParameters.GetParameters,
    @path id: eInnsynId<T>,
  ): Responses.OkResponse<T>;

  /**
   * Update an object.
   * @param id The ID of the object.
   * @returns The updated object.
   */
  @route("/{id}")
  @patch
  update(@path id: eInnsynId<T>, @body body: T): Responses.OkResponse<T>;

  /**
   * Delete an object.
   * @param id The ID of the object.
   * @returns The deleted object.
   */
  @route("/{id}")
  @delete
  delete(@path id: eInnsynId<T>): Responses.OkResponse<T>;
}

interface GloballyRoutable<T extends Base.Base> extends Routable<T> {
  @route("/")
  @get
  list(...QueryParameters.ListParameters): Responses.ListResponse<T>;

  @route("/")
  @post
  add(@body body: T): Responses.AddResponse<T>;
}

namespace QueryParameters {
  model GetParameters {
    /**
     * Specifies which fields in the response should be expanded.
     */
    @query expand?: string[];
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
    @oneOf @query sortOrder?: "asc" | "desc";

    /**
     * A cursor for use in pagination. StartingAfter is a resource ID that defines your place in the list.
     */
    @query startingAfter?: eInnsynId;

    /**
     * A cursor for use in pagination. EndingBefore is a resource ID that defines your place in the list.
     */
    @query endingBefore?: eInnsynId;

    /**
     * A list of resource IDs to be returned. If this parameter is used, the other parameters will be ignored.
     */
    @query ids?: eInnsynId[];

    /**
     * A list of external IDs to be returned. If this parameter is used, the other parameters will be ignored.
     */
    @query externalIds?: string[];

    /**
     * The Journalenhet to filter the result set by.
     */
    @query journalenhet?: eInnsynId;
  }

  model SearchParameters extends ListParameters {
    /**
     * A query string to filter by. Quotes can be used to search for exact matches or phrases. Words can be excluded by prefixing them with a minus sign.
     */
    @query query?: string;

    /**
     * A list of enhet IDs to filter by. This will also match subenhets.
     */
    @query administrativEnhet?: eInnsynId[];

    /**
     * A list of enhet IDs to filter by. This will only match the specified enhets, not subenhets.
     */
    @query administrativEnhetExact?: eInnsynId[];

    /**
     * A list of enhet IDs to exclude from the result set. This will also exclude subenhets.
     */
    @query excludeAdministrativEnhet?: eInnsynId[];

    /**
     * A list of enhet IDs to exclude from the result set. This will only exclude the specified enhets, not subenhets.
     */
    @query excludeAdministrativEnhetExact?: eInnsynId[];

    /**
     * Filter by the published date of the document.
     */
    @query publisertDatoBefore?: utcDateTime;

    /**
     * Filter by the published date of the document.
     */
    @query publisertDatoAfter?: utcDateTime;

    /**
     * Filter by the updated date of the document.
     */
    @query oppdatertDatoBefore?: utcDateTime;

    /**
     * Filter by the updated date of the document.
     */
    @query oppdatertDatoAfter?: utcDateTime;

    /**
     * Filter by the date of a meeting.
     */
    @query moetedatoBefore?: utcDateTime;

    /**
     * Filter by the date of a meeting.
     */
    @query moetedatoAfter?: utcDateTime;
  }
}
