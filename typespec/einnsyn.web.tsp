import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "./einnsyn.Base.tsp";
import "./einnsyn.noark.tsp";

using Http;
using OpenAPI;
using eInnsyn;

namespace eInnsyn;

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
  interface BrukerRoutes extends GloballyRoutable<Bruker, "Bruker"> {
    @route("/{brukerId}/innsynskrav")
    @get
    getInnsynskravList(
      @path brukerId: EInnsynId,
    ): Responses.ListResponse<Innsynskrav.Innsynskrav>;

    @route("/{brukerId}/innsynskrav")
    @post
    addInnsynskrav(
      @path brukerId: EInnsynId,
      @body innsynskrav: Innsynskrav.Innsynskrav,
    ): Responses.AddResponse<Innsynskrav.Innsynskrav>;

    @route("/{brukerId}/innsynskravDel")
    @get
    getInnsynskravDelList(
      @path brukerId: EInnsynId,
    ): Responses.ListResponse<InnsynskravDel.InnsynskravDel>;

    @route("/{brukerId}/lagretSak")
    @get
    getLagretSakList(
      @path brukerId: EInnsynId,
    ): Responses.ListResponse<LagretSak.LagretSak>;

    @route("/{brukerId}/lagretSak")
    @post
    addLagretSak(
      @path brukerId: EInnsynId,
      @body lagretSak: LagretSak.LagretSak,
    ): Responses.AddResponse<LagretSak.LagretSak>;

    @route("/{brukerId}/lagretSoek")
    @get
    getLagretSoekList(
      @path brukerId: EInnsynId,
    ): Responses.ListResponse<LagretSoek.LagretSoek>;

    @route("/{brukerId}/lagretSoek")
    @post
    addLagretSoek(
      @path brukerId: EInnsynId,
      @body lagretSoek: LagretSoek.LagretSoek,
    ): Responses.AddResponse<LagretSoek.LagretSoek>;

    @route("/{brukerId}/activate/{secret}")
    @patch
    activate(
      @path brukerId: EInnsynId,
      @path secret: string,
    ): Responses.OkResponse<Bruker>;

    @route("/{brukerId}/updatePassword")
    @patch
    updatePassword(
      @path brukerId: EInnsynId,
      @body password: string,
    ): Responses.OkResponse<Bruker>;

    @route("/{brukerId}/updatePassword/{secret}")
    @patch
    updatePasswordWithSecret(
      @path brukerId: EInnsynId,
      @path secret: string,
      @body password: string,
    ): Responses.OkResponse<Bruker>;

    @route("/{brukerId}/requestPasswordReset")
    @patch
    requestPasswordReset(
      @path brukerId: EInnsynId,
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
    bruker: EInnsynId | Bruker.Bruker;
    saksmappe?: EInnsynId | Saksmappe.Saksmappe;
    moetemappe?: EInnsynId | Moetemappe.Moetemappe;
    subscribe?: boolean;
  }

  @route("/lagretSak")
  @tag("LagretSak")
  interface LagretSakRoutes extends Routable<LagretSak, "LagretSak"> {}
}

namespace LagretSoek {
  /**
   * LagretSoek
   */
  @extension("x-resourceId", "LagretSoek")
  @extension("x-idPrefix", "lsoek")
  model LagretSoek extends Base.Base {
    @visibility("read") entity?: "LagretSoek";
    bruker?: EInnsynId | Bruker.Bruker;
    label?: string;
    legacyQuery?: string;
    subscribe?: boolean;
  }

  @route("/lagretSoek")
  @tag("LagretSoek")
  interface LagretSoekRoutes extends Routable<LagretSoek, "LagretSoek"> {}
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
  interface TilbakemeldingRoutes
    extends GloballyRoutable<Tilbakemelding, "Tilbakemelding"> {}
}

namespace Innsynskrav {
  /**
   * Innsynskrav
   */
  @extension("x-resourceId", "Innsynskrav")
  @extension("x-idPrefix", "ik")
  model Innsynskrav extends Base.Base {
    @visibility("read") entity?: "Innsynskrav";
    @format("email") email: string;
    innsynskravDel: (EInnsynId | InnsynskravDel.InnsynskravDel)[];
    verified?: boolean;
    bruker?: EInnsynId | Bruker.Bruker;
    language?: "nb" | "nn" | "en" | "se";
  }

  @route("/innsynskrav")
  @tag("Innsynskrav")
  interface InnsynskravRoutes
    extends GloballyRoutable<Innsynskrav, "Innsynskrav"> {
    @route("/{innsynskravId}/innsynskravDel")
    @get
    getInnsynskravDelList(
      @path innsynskravId: EInnsynId,
    ): Responses.ListResponse<InnsynskravDel.InnsynskravDel>;

    @route("/{innsynskravId}/verify/{secret}")
    @patch
    verify(
      @path innsynskravId: EInnsynId,
      @path secret: string,
    ): Responses.OkResponse<Innsynskrav>;
  }
}

namespace InnsynskravDel {
  /**
   * InnsynskravDel
   */
  @extension("x-resourceId", "InnsynskravDel")
  @extension("x-idPrefix", "ikd")
  model InnsynskravDel extends Base.Base {
    @visibility("read") entity?: "InnsynskravDel";
    innsynskrav?: EInnsynId | Innsynskrav.Innsynskrav;
    journalpost: EInnsynId | Journalpost.Journalpost;
    enhet?: EInnsynId | Enhet.Enhet;
    @visibility("read") @format("email") email?: string;
    sent?: utcDateTime;
  }

  @route("/innsynskravDel")
  @tag("InnsynskravDel")
  interface InnsynskravDelRoutes
    extends Routable<InnsynskravDel, "InnsynskravDel"> {}
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
