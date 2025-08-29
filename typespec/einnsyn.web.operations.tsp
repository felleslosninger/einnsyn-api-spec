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
    @patch
    activate(
      @path id: eInnsynId<Bruker>,
      @path secret: string,
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/updatePassword")
    @patch
    updatePassword(
      @path id: eInnsynId<Bruker>,
      @body updatePassword: {
        @format("password") oldPassword: string;
        @format("password") newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/updatePassword/{secret}")
    @patch
    updatePasswordWithSecret(
      @path id: eInnsynId<Bruker>,
      @path secret: string,
      @body updatePasswordWithSecret: {
        @format("password") newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/requestPasswordReset")
    @patch
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
    @patch
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
      | "score"
      | "id"
      | "entity"
      | "publisertDato"
      | "oppdatertDato"
      | "moetedato"
      | "fulltekst"
      | "type" = "score";
  }
  @route("/search")
  @tag("Search")
  interface SearchRoutes {
    @route("")
    @get
    search(...SearchParameters): Responses.ListResponse<Base.Base>;
  }
}

namespace Statistics {
  /**
   * Statistics parameters
   */
  model StatisticsParameters extends QueryParameters.FilterParameters {
    @query aggregateFrom?: plainDate;
    @query aggregateTo?: plainDate;
  }
  model StatisticsResponse {
    @statusCode _: 200;

    @body
    body: {
      @visibility(Lifecycle.Read) innsynskrav?: {
        @visibility(Lifecycle.Read) count: integer;
        @visibility(Lifecycle.Read) interval: integer;
        @visibility(Lifecycle.Read) bucket: {
          @visibility(Lifecycle.Read) time: utcDateTime;
          @visibility(Lifecycle.Read) count: integer;
        }[];
      };
      @visibility(Lifecycle.Read) download?: {
        @visibility(Lifecycle.Read) count: integer;
        @visibility(Lifecycle.Read) interval: integer;
        @visibility(Lifecycle.Read) bucket: {
          @visibility(Lifecycle.Read) time: utcDateTime;
          @visibility(Lifecycle.Read) count: integer;
        }[];
      };
    };
  }

  @route("/statistics")
  @tag("Statistics")
  interface Statistics {
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
