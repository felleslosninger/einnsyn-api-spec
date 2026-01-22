import "@typespec/http";
import "@typespec/openapi";
import "./einnsyn.arkiv.models.tsp";
import "./einnsyn.arkiv.operations.tsp";
import "./einnsyn.web.models.tsp";
import "./einnsyn.responses.tsp";
import "./einnsyn.queryparameters.tsp";

using TypeSpec.Http;

namespace EInnsyn;

namespace Bruker {
  model ListByBrukerParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Bruker>;
    @query brukerId: eInnsynId<Bruker>;
  }

  @route("/bruker")
  @tag("Bruker")
  interface BrukerRoutes extends GloballyRoutable<Bruker> {
    @route("/{id}/innsynskravBestilling")
    @get
    listInnsynskravBestilling(
      ...ListByBrukerParameters,
    ): Responses.ListResponse<InnsynskravBestilling.InnsynskravBestilling>;

    @route("/{id}/innsynskravBestilling")
    @post
    addInnsynskravBestilling(
      @path id: eInnsynId<Bruker>,
      @body innsynskravBestilling: InnsynskravBestilling.InnsynskravBestilling,
    ): Responses.AddResponse<InnsynskravBestilling.InnsynskravBestilling>;

    @route("/{id}/innsynskrav")
    @get
    listInnsynskrav(
      ...ListByBrukerParameters,
    ): Responses.ListResponse<Innsynskrav.Innsynskrav>;

    @route("/{id}/lagretSak")
    @get
    listLagretSak(
      ...ListByBrukerParameters,
    ): Responses.ListResponse<LagretSak.LagretSak>;

    @route("/{id}/lagretSak")
    @post
    addLagretSak(
      @path id: eInnsynId<Bruker>,
      @body lagretSak: LagretSak.LagretSak,
    ): Responses.AddResponse<LagretSak.LagretSak>;

    @route("/{id}/lagretSoek")
    @get
    listLagretSoek(
      ...ListByBrukerParameters,
    ): Responses.ListResponse<LagretSoek.LagretSoek>;

    @route("/{id}/lagretSoek")
    @post
    addLagretSoek(
      @path id: eInnsynId<Bruker>,
      @body lagretSoek: LagretSoek.LagretSoek,
    ): Responses.AddResponse<LagretSoek.LagretSoek>;

    @route("/{id}/activate/{secret}")
    @patch(#{ implicitOptionality: true })
    activate(
      @path id: eInnsynId<Bruker>,
      @path secret: string,
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/updatePassword")
    @patch(#{ implicitOptionality: true })
    updatePassword(
      @path id: eInnsynId<Bruker>,
      @body updatePassword: {
        @format("password") oldPassword: string;
        @format("password") newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/updatePassword/{secret}")
    @patch(#{ implicitOptionality: true })
    updatePasswordWithSecret(
      @path id: eInnsynId<Bruker>,
      @path secret: string,
      @body updatePasswordWithSecret: {
        @format("password") newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/requestPasswordReset")
    @patch(#{ implicitOptionality: true })
    requestPasswordReset(
      @path id: eInnsynId<Bruker>,
    ): Responses.OkResponse<Bruker>;
  }
}

namespace Innsynskrav {
  model ListByInnsynskravParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Innsynskrav>;
    @query innsynskravId: eInnsynId<Innsynskrav>;
  }

  @route("/innsynskrav")
  @tag("Innsynskrav")
  interface InnsynskravRoutes extends Routable<Innsynskrav> {}
}

namespace InnsynskravBestilling {
  model ListByInnsynskravBestillingParameters
    extends QueryParameters.ListParameters {
    @path id: eInnsynId<InnsynskravBestilling>;
    @query innsynskravBestillingId: eInnsynId<InnsynskravBestilling>;
  }

  @route("/innsynskravBestilling")
  @tag("InnsynskravBestilling")
  interface InnsynskravRoutes extends GloballyRoutable<InnsynskravBestilling> {
    @route("/{id}/innsynskrav")
    @get
    listInnsynskrav(
      ...ListByInnsynskravBestillingParameters,
    ): Responses.ListResponse<Innsynskrav.Innsynskrav>;

    @route("/{id}/verify/{secret}")
    @patch(#{ implicitOptionality: true })
    verify(
      @path id: eInnsynId,
      @path secret: string,
    ): Responses.OkResponse<InnsynskravBestilling>;
  }
}

namespace LagretSak {
  @route("/lagretSak")
  @tag("LagretSak")
  interface LagretSakRoutes extends Routable<LagretSak> {}
}

namespace LagretSoek {
  @route("/lagretSoek")
  @tag("LagretSoek")
  interface LagretSoekRoutes extends Routable<LagretSoek> {}
}

namespace Tilbakemelding {
  @route("/tilbakemelding")
  @tag("Tilbakemelding")
  interface TilbakemeldingRoutes extends GloballyRoutable<Tilbakemelding> {}
}

namespace Search {
  /**
   * Search parameters
   */
  model SearchParameters extends QueryParameters.FilterParameters {
    /**
     * Specifies which fields in the response should be expanded.
     */
    @query expand?: string[];

    /**
     * A limit on the number of objects to be returned. Limit can range between 1 and 100, and the default is 25.
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
     * A cursor for use in pagination. This is a list of size two, the value of the sortBy property and the unique id.
     */
    @query startingAfter?: string[];

    /**
     * A cursor for use in pagination. This is a list of size two, the value of the sortBy property and the unique id.
     */
    @query endingBefore?: string[];

    /**
     * The field to sort results by. The default is "score".
     */
    @query sortBy?:
      | "administrativEnhetNavn"
      | "dokumentetsDato"
      | "entity"
      | "fulltekst"
      | "id"
      | "journaldato"
      | "journalpostnummer"
      | "journalposttype"
      | "korrespondansepartNavn"
      | "moetedato"
      | "oppdatertDato"
      | "publisertDato"
      | "sakssekvensnummer"
      | "score"
      | "tittel" = "score";
  }
  @route("/search")
  @tag("Search")
  interface SearchRoutes {
    @route("")
    @get
    search(...SearchParameters): Responses.ListResponse<Base.Base>;
  }
}

/**
 * Statistics namespace for querying usage and activity metrics
 */
namespace Statistics {
  /**
   * Parameters for querying statistics data
   */
  model StatisticsParameters extends QueryParameters.FilterParameters {
    /**
     * The start date for aggregating statistics. If not provided, it will be set to one year before `aggregateTo`.
     */
    @query aggregateFrom?: plainDate;

    /**
     * The end date for aggregating statistics. If not provided, statistics up to the current date will be included.
     */
    @query aggregateTo?: plainDate;

    /**
     * The preferred time interval for aggregating statistics data. Determines how data points are grouped in the time series.
     * Note: There is a maximum limit of 1000 data points in the time series. If the requested interval combined with the
     * date range would exceed this limit, the interval will be automatically adjusted to a larger granularity to stay
     * within the limit. Default is "hour".
     */
    @query aggregateInterval?:
      | "hour"
      | "day"
      | "week"
      | "month"
      | "year" = "hour";
  }
  /**
   * Response containing statistics data with summary and optional time series
   */
  model StatisticsResponse {
    @statusCode _: 200;

    @body
    body: {
      /**
       * Aggregated summary of statistics over the entire queried period
       */
      @visibility(Lifecycle.Read) summary: {
        /**
         * Total number of entities created in the period
         */
        @visibility(Lifecycle.Read) createdCount: integer;

        /**
         * Total number of entities created with fulltext content in the period
         */
        @visibility(Lifecycle.Read) createdWithFulltextCount: integer;

        /**
         * Total number of innsynskrav (access requests) created in the period
         */
        @visibility(Lifecycle.Read) createdInnsynskravCount: integer;

        /**
         * Total number of document downloads in the period
         */
        @visibility(Lifecycle.Read) downloadCount: integer;
      };

      @visibility(Lifecycle.Read) metadata: {
        /**
         * The aggregation interval used for the time series data
         */
        @visibility(Lifecycle.Read) aggregateInterval: string;

        /**
         * The start date for the aggregated statistics
         */
        @visibility(Lifecycle.Read) aggregateFrom?: plainDate;

        /**
         * The end date for the aggregated statistics
         */
        @visibility(Lifecycle.Read) aggregateTo?: plainDate;
      };

      /**
       * Time series data showing statistics broken down by the specified aggregation interval.
       * Each entry represents metrics for a specific time period.
       */
      @visibility(Lifecycle.Read) timeSeries?: {
        /**
         * The timestamp for this time series data point
         */
        @visibility(Lifecycle.Read) time: utcDateTime;

        /**
         * Number of entities created during this time interval
         */
        @visibility(Lifecycle.Read) createdCount: integer;

        /**
         * Number of entities created with fulltext content during this time interval
         */
        @visibility(Lifecycle.Read) createdWithFulltextCount: integer;

        /**
         * Number of innsynskrav (access requests) created during this time interval
         */
        @visibility(Lifecycle.Read) createdInnsynskravCount: integer;

        /**
         * Number of document downloads during this time interval
         */
        @visibility(Lifecycle.Read) downloadCount: integer;
      }[];
    };
  }

  /**
   * Statistics API endpoints for querying usage and activity metrics
   */
  @route("/statistics")
  @tag("Statistics")
  interface Statistics {
    /**
     * Query statistics data with optional filtering and aggregation parameters.
     * Returns both a summary of total statistics and optional time series data.
     */
    @route("")
    @get
    query(...StatisticsParameters): StatisticsResponse;
  }
}

namespace AuthInfo {
  model AuthInfo {
    @visibility(Lifecycle.Read) entity: "AuthInfo";

    @visibility(Lifecycle.Read)
    authType: "Ansattporten" | "ApiKey" | "Bruker";

    @visibility(Lifecycle.Read) type: "Bruker" | "Enhet";
    @visibility(Lifecycle.Read) id: eInnsynId<Bruker | Enhet>;
    @visibility(Lifecycle.Read) orgnummer?: string;
    @visibility(Lifecycle.Read) email?: string;
  }

  model AuthInfoResponse {
    @statusCode _: 200;
    @body body: AuthInfo;
  }

  @route("/me")
  @tag("AuthInfo")
  interface AuthInfoRoutes {
    @route("")
    @get
    get(): AuthInfoResponse;
  }
}
