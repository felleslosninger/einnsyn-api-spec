import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.base.tsp";
import "./einnsyn.noark.tsp";

using Http;
using OpenAPI;
using EInnsyn;

namespace EInnsyn;

namespace Bruker {
  model ListByBrukerParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Bruker>;
    @query brukerId: eInnsynId<Bruker>;
  }

  /**
   * eInnsyn bruker
   */
  @extension("x-resourceId", "Bruker")
  @extension("x-idPrefix", "bru")
  model Bruker extends Base.Base {
    @visibility("read") entity?: "Bruker";
    @format("email") email: string;
    @visibility("read") active: boolean;
    password?: string;
    language?: "nb" | "nn" | "en" | "se" = "nb";
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

namespace LagretSak {
  /**
   * LagretSak
   */
  @extension("x-resourceId", "LagretSak")
  @extension("x-idPrefix", "lsak")
  model LagretSak extends Base.Base {
    @visibility("read") entity?: "LagretSak";
    bruker: ExpandableField<Bruker.Bruker>;
    saksmappe?: ExpandableField<Saksmappe.Saksmappe>;
    moetemappe?: ExpandableField<Moetemappe.Moetemappe>;
    subscribe?: boolean;
  }

  @route("/lagretSak")
  @tag("LagretSak")
  interface LagretSakRoutes extends Routable<LagretSak> {}
}

namespace LagretSoek {
  /**
   * LagretSoek
   */
  @extension("x-resourceId", "LagretSoek")
  @extension("x-idPrefix", "lsoek")
  model LagretSoek extends Base.Base {
    @visibility("read") entity?: "LagretSoek";
    bruker?: ExpandableField<Bruker.Bruker>;
    label?: string;
    legacyQuery?: string;
    subscribe?: boolean;
  }

  @route("/lagretSoek")
  @tag("LagretSoek")
  interface LagretSoekRoutes extends Routable<LagretSoek> {}
}

namespace Tilbakemelding {
  /**
   * Tilbakemelding
   */
  @extension("x-resourceId", "Tilbakemelding")
  @extension("x-idPrefix", "tbm")
  model Tilbakemelding extends Base.Base {
    @visibility("read") entity?: "Tilbakemelding";
    messageFromUser?: string;
    path?: string;
    referer?: string;
    userAgent?: string;
    screenHeight?: integer;
    screenWidth?: integer;
    docHeight?: integer;
    docWidth?: integer;
    winHeight?: integer;
    winWidth?: integer;
    scrollX?: integer;
    scrollY?: integer;
    userSatisfied?: boolean;
    handledByAdmin?: boolean;
    adminComment?: string;
  }

  @route("/tilbakemelding")
  @tag("Tilbakemelding")
  interface TilbakemeldingRoutes extends GloballyRoutable<Tilbakemelding> {}
}

namespace InnsynskravBestilling {
  /**
   * Innsynskrav
   */
  @extension("x-resourceId", "Innsynskrav")
  @extension("x-idPrefix", "ik")
  model InnsynskravBestilling extends Base.Base {
    @visibility("read") entity?: "Innsynskrav";
    @format("email") email: string;
    innsynskrav: ExpandableField<Innsynskrav.Innsynskrav>[];
    verified?: boolean;
    bruker?: ExpandableField<Bruker.Bruker>;
    language?: "nb" | "nn" | "en" | "se";
  }

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

namespace Innsynskrav {
  /**
   * Innsynskrav
   */
  @extension("x-resourceId", "Innsynskrav")
  @extension("x-idPrefix", "ikd")
  model Innsynskrav extends Base.Base {
    @visibility("read") entity?: "Innsynskrav";
    innsynskravBestilling?: ExpandableField<InnsynskravBestilling.InnsynskravBestilling>;
    journalpost: ExpandableField<Journalpost.Journalpost>;
    enhet?: ExpandableField<Enhet.Enhet>;
    @visibility("read") @format("email") email?: string;
    sent?: utcDateTime;
  }

  model ListByInnsynskravParameters extends QueryParameters.ListParameters {
    @path id: eInnsynId<Innsynskrav>;
    @query innsynskravId: eInnsynId<Innsynskrav>;
  }

  @route("/innsynskrav")
  @tag("Innsynskrav")
  interface InnsynskravRoutes extends Routable<Innsynskrav> {}
}

namespace Search {
// model SearchResponse
//   extends Responses.ListResponseBody<
//     | Journalpost.Journalpost
//     | Moetemappe.Moetemappe
//     | Moetesak.Moetesak
//     | Saksmappe.Saksmappe> {}
// /**
//  * Search journal data
//  */
// @route("/search")
// @tag("Search")
// interface SearchRoutes {
//   @get
//   search(...QueryParameters.SearchParameters): Responses.ListResponse<
//     | Journalpost.Journalpost
//     | Moetemappe.Moetemappe
//     | Moetesak.Moetesak
//     | Saksmappe.Saksmappe>;
// }

}
