import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.models.tsp";

using Http;

namespace EInnsyn;

namespace QueryParameters {
  /**
   * A date parameter that accepts either absolute dates (ISO 8601) or relative date expressions.
   *
   * **Absolute date formats:**
   * - ISO 8601 date: `2024-01-15`
   * - ISO 8601 datetime: `2024-01-15T10:30:00Z`
   *
   * **Relative date syntax (similar to Grafana/Elasticsearch):**
   * - `now` - current time
   * - `now-<amount><unit>` - relative to now, e.g., `now-1d`, `now-7d`, `now-1M`, `now-1y`
   * - `now+<amount><unit>` - future relative to now, e.g., `now+1d`
   * - `now/<unit>` - rounded to unit, e.g., `now/d` (start of day), `now/M` (start of month)
   * - `now-<amount><unit>/<unit>` - combined, e.g., `now-1d/d` (start of yesterday)
   *
   * Supported units: ms (milliseconds), s (seconds), m (minutes), h/H (hours), d (days), w (weeks), M (months), y (years)
   */
  scalar timeString extends string;

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
     * Filter by title. This is a free text search.
     */
    @query tittel?: string[];

    /**
     * Filter by sender/recipient name. This is a free text search.
     */
    @query korrespondansepartNavn?: string[];

    /**
     * Filter by legal basis for exemption. This is a free text search.
     */
    @query skjermingshjemmel?: string[];

    /**
     * Filter by the published date of the document.
     */
    @query publisertDatoFrom?: timeString;

    /**
     * Filter by the published date of the document.
     */
    @query publisertDatoTo?: timeString;

    /**
     * Filter by the updated date of the document.
     */
    @query oppdatertDatoFrom?: timeString;

    /**
     * Filter by the updated date of the document.
     */
    @query oppdatertDatoTo?: timeString;

    /**
     * Filter by journal date.
     */
    @query journaldatoFrom?: timeString;

    /**
     * Filter by journal date.
     */
    @query journaldatoTo?: timeString;

    /**
     * Filter by document date.
     */
    @query dokumentetsDatoFrom?: timeString;

    /**
     * Filter by document date.
     */
    @query dokumentetsDatoTo?: timeString;

    /**
     * Filter by the date of a meeting.
     */
    @query moetedatoFrom?: timeString;

    /**
     * Filter by the date of a meeting.
     */
    @query moetedatoTo?: timeString;

    /**
     * Filter by the legacy "standardDato". This is the default date for each entity type.
     * For instance, for Moetemappe this would be "moetedato", for Journalpost this would be "journaldato".
     */
    @query standardDatoFrom?: timeString;

    /**
     * Filter by the legacy "standardDato". This is the default date for each entity type.
     * For instance, for Moetemappe this would be "moetedato", for Journalpost this would be "journaldato".
     */
    @query standardDatoTo?: timeString;

    /**
     * Filter by saksaar
     */
    @query saksaar?: string[];

    /**
     * Filter by sakssekvensnummer
     */
    @query sakssekvensnummer?: string[];

    /**
     * Filter by saksnummer
     */
    @query saksnummer?: string[];

    /**
     * Filter by journalpostnummer
     */
    @query journalpostnummer?: string[];

    /**
     * Filter by journalsekvensnummer
     */
    @query journalsekvensnummer?: string[];

    /**
     * Filter by moetesaksaar
     */
    @query moetesaksaar?: string[];

    /**
     * Filter by moetesakssekvensnummer
     */
    @query moetesakssekvensnummer?: string[];

    /**
     * Filter by journalposttype
     */
    @query
    journalposttype?: (
      | "inngaaende_dokument"
      | "utgaaende_dokument"
      | "organinternt_dokument_uten_oppfoelging"
      | "organinternt_dokument_for_oppfoelging"
      | "saksframlegg"
      | "sakskart"
      | "moeteprotokoll"
      | "moetebok"
      | "ukjent")[];

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
