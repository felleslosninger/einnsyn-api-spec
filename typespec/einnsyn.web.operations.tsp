import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
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
        oldPassword: string;
        newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{id}/updatePassword/{secret}")
    @patch
    updatePasswordWithSecret(
      @path id: eInnsynId<Bruker>,
      @path secret: string,
      @body updatePasswordWithSecret: {
        newPassword: string;
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
