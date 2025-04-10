import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.models.tsp";

using Http;

namespace EInnsyn;

namespace QueryParameters {
  model QueryParameters {}
  model GetParameters extends QueryParameters {
    /**
     * Specifies which fields in the response should be expanded.
     */
    @query expand?: string[];
  }

  model ListParameters extends QueryParameters {
    /**
     * Specifies which fields in the response should be expanded.
     */
    @query expand?: string[];

    /**
     * A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 10.
     */
    @minValue(1)
    @maxValue(100)
    @query
    limit?: integer = 25;

    /**
     * The sort order of the result set. The default is ascending.
     */
    @query sortOrder?: "asc" | "desc" = "desc";

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

  model FilterParameters extends QueryParameters {
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

    /**
     * Filter by the entity type.
     */
    @query entity?: ("Journalpost" | "Moetemappe" | "Moetesak" | "Saksmappe")[];

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

    /**
     * Match documents with (or without) fulltext.
     */
    @query fulltext?: boolean;
  }
}
