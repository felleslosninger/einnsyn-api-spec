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
  /**
   * eInnsyn bruker
   */
  @extension("x-resourceId", "Bruker")
  @extension("x-idPrefix", "bru")
  model Bruker extends Base.Base {
    @visibility("read") entity?: "Bruker";
    @format("email") email: string;
    @visibility("read") active: boolean;
    language?: "nb" | "nn" | "en" | "se" = "nb";
  }

  @route("/bruker")
  @tag("Bruker")
  interface BrukerRoutes extends GloballyRoutable<Bruker> {
    @route("/{brukerId}/innsynskravBestilling")
    @get
    listInnsynskravBestilling(
      ...QueryParameters.ListParameters,
      @path brukerId: eInnsynId<Bruker>,
    ): Responses.ListResponse<InnsynskravBestilling.InnsynskravBestilling>;

    @route("/{brukerId}/innsynskravBestilling")
    @post
    addInnsynskravBestilling(
      @path brukerId: eInnsynId<Bruker>,
      @body innsynskravBestilling: InnsynskravBestilling.InnsynskravBestilling,
    ): Responses.AddResponse<InnsynskravBestilling.InnsynskravBestilling>;

    @route("/{brukerId}/innsynskrav")
    @get
    listInnsynskrav(
      ...QueryParameters.ListParameters,
      @path brukerId: eInnsynId<Bruker>,
    ): Responses.ListResponse<Innsynskrav.Innsynskrav>;

    @route("/{brukerId}/lagretSak")
    @get
    listLagretSak(
      ...QueryParameters.ListParameters,
      @path brukerId: eInnsynId<Bruker>,
    ): Responses.ListResponse<LagretSak.LagretSak>;

    @route("/{brukerId}/lagretSak")
    @post
    addLagretSak(
      @path brukerId: eInnsynId<Bruker>,
      @body lagretSak: LagretSak.LagretSak,
    ): Responses.AddResponse<LagretSak.LagretSak>;

    @route("/{brukerId}/lagretSoek")
    @get
    listLagretSoek(
      ...QueryParameters.ListParameters,
      @path brukerId: eInnsynId<Bruker>,
    ): Responses.ListResponse<LagretSoek.LagretSoek>;

    @route("/{brukerId}/lagretSoek")
    @post
    addLagretSoek(
      @path brukerId: eInnsynId<Bruker>,
      @body lagretSoek: LagretSoek.LagretSoek,
    ): Responses.AddResponse<LagretSoek.LagretSoek>;

    @route("/{brukerId}/activate/{secret}")
    @patch
    activate(
      @path brukerId: eInnsynId<Bruker>,
      @path secret: string,
    ): Responses.OkResponse<Bruker>;

    @route("/{brukerId}/updatePassword")
    @patch
    updatePassword(
      @path brukerId: eInnsynId<Bruker>,
      @body updatePassword: {
        oldPassword: string;
        newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{brukerId}/updatePassword/{secret}")
    @patch
    updatePasswordWithSecret(
      @path brukerId: eInnsynId<Bruker>,
      @path secret: string,
      @body updatePasswordWithSecret: {
        newPassword: string;
      },
    ): Responses.OkResponse<Bruker>;

    @route("/{brukerId}/requestPasswordReset")
    @patch
    requestPasswordReset(
      @path brukerId: eInnsynId<Bruker>,
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
    bruker: ExpandableObject<Bruker.Bruker>;
    saksmappe?: ExpandableObject<Saksmappe.Saksmappe>;
    moetemappe?: ExpandableObject<Moetemappe.Moetemappe>;
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
    bruker?: ExpandableObject<Bruker.Bruker>;
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
    innsynskrav: ExpandableObject<Innsynskrav.Innsynskrav>[];
    verified?: boolean;
    bruker?: ExpandableObject<Bruker.Bruker>;
    language?: "nb" | "nn" | "en" | "se";
  }

  @route("/innsynskravBestilling")
  @tag("InnsynskravBestilling")
  interface InnsynskravRoutes extends GloballyRoutable<InnsynskravBestilling> {
    @route("/{innsynskravBestillingId}/innsynskrav")
    @get
    listInnsynskrav(
      ...QueryParameters.ListParameters,
      @path innsynskravBestillingId: eInnsynId<InnsynskravBestilling>,
    ): Responses.ListResponse<Innsynskrav.Innsynskrav>;

    @route("/{innsynskravBestillingId}/verify/{secret}")
    @patch
    verify(
      @path innsynskravBestillingId: eInnsynId,
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
    innsynskravBestilling?: ExpandableObject<InnsynskravBestilling.InnsynskravBestilling>;
    journalpost: ExpandableObject<Journalpost.Journalpost>;
    enhet?: ExpandableObject<Enhet.Enhet>;
    @visibility("read") @format("email") email?: string;
    sent?: utcDateTime;
  }

  @route("/innsynskrav")
  @tag("Innsynskrav")
  interface InnsynskravRoutes extends Routable<Innsynskrav> {}
}

namespace Search {
  /**
   * Search journal data
   */
  @route("/search")
  @tag("Search")
  interface SearchRoutes {
    @get
    get(...QueryParameters.SearchParameters): Responses.ListResponse<
      | Journalpost.Journalpost
      | Moetemappe.Moetemappe
      | Moetesak.Moetesak
      | Saksmappe.Saksmappe>;
  }
}
