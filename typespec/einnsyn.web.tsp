import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";
import "@typespec/rest";
import "./einnsyn.base.tsp";
import "./einnsyn.noark.tsp";

using Http;
using OpenAPI;
using Rest;
using eInnsyn;
using eInnsyn.noark;

namespace eInnsyn.web;

/**
 * eInnsyn bruker
 */
@extension("x-resourceId", "Bruker")
@extension("x-idPrefix", "bru")
model Bruker extends EInnsynBase {
  @visibility("read") entity?: "Bruker";
  @format("email") email: string;
  @format("password") password: string;
  @visibility("read") active: boolean;
  language?: "nb" | "nn" | "en" | "se" = "nb";
}

@route("/bruker")
@tag("Bruker")
interface BrukerRoutes extends GloballyRoutable<Bruker, "Bruker"> {
  @route("/{brukerId}/innsynskrav")
  @get
  @operationId("GetBrukerInnsynskravList")
  getInnsynskravList(@path brukerId: EInnsynId): ResponseList<Innsynskrav>;

  @route("/{brukerId}/innsynskrav")
  @post
  @operationId("PostBrukerInnsynskrav")
  addInnsynskrav(
    @path brukerId: EInnsynId,
    @body innsynskrav: Innsynskrav,
  ): Innsynskrav;

  @route("/{brukerId}/innsynskravDel")
  @get
  @operationId("GetBrukerInnsynskravDelList")
  getInnsynskravDelList(
    @path brukerId: EInnsynId,
  ): ResponseList<InnsynskravDel>;

  @route("/{brukerId}/lagretSak")
  @get
  @operationId("GetBrukerLagretSakList")
  getLagretSakList(@path brukerId: EInnsynId): ResponseList<LagretSak>;

  @route("/{brukerId}/lagretSak")
  @post
  @operationId("PostBrukerLagretSak")
  addLagretSak(
    @path brukerId: EInnsynId,
    @body lagretSak: LagretSak,
  ): LagretSak;

  @route("/{brukerId}/lagretSoek")
  @get
  @operationId("GetBrukerLagretSoekList")
  getLagretSoekList(@path brukerId: EInnsynId): ResponseList<LagretSoek>;

  @route("/{brukerId}/lagretSoek")
  @post
  @operationId("PostBrukerLagretSoek")
  addLagretSoek(
    @path brukerId: EInnsynId,
    @body lagretSoek: LagretSoek,
  ): LagretSoek;

  @route("/{brukerId}/activate/{secret}")
  @put
  @operationId("PutBrukerActivate")
  activate(@path brukerId: EInnsynId, @path secret: string): Bruker;

  @route("/{brukerId}/updatePassword")
  @put
  @operationId("PutBrukerPassword")
  updatePassword(@path brukerId: EInnsynId, @body password: string): Bruker;

  @route("/{brukerId}/updatePassword/{secret}")
  @put
  @operationId("PutBrukerPasswordWithSecret")
  updatePasswordWithSecret(
    @path brukerId: EInnsynId,
    @path secret: string,
    @body password: string,
  ): Bruker;

  @route("/{brukerId}/requestPasswordReset")
  @put
  @operationId("RequestPasswordReset")
  requestPasswordReset(@path brukerId: EInnsynId): Bruker;
}

/**
 * LagretSak
 */
@extension("x-resourceId", "LagretSoek")
@extension("x-idPrefix", "lsoek")
model LagretSoek extends EInnsynBase {
  @visibility("read") entity?: "LagretSoek";
  bruker?: EInnsynId | Bruker;
  label?: string;
  legacyQuery?: string;
  subscribe?: boolean;
}

@route("/lagretSak")
@tag("LagretSak")
interface LagretSakRoutes extends Routable<LagretSak, "LagretSak"> {}

/**
 * LagretSoek
 */
@extension("x-resourceId", "LagretSak")
@extension("x-idPrefix", "lsak")
model LagretSak extends EInnsynBase {
  @visibility("read") entity?: "LagretSak";
  bruker: EInnsynId | Bruker;
  saksmappe?: EInnsynId | Saksmappe;
  moetemappe?: EInnsynId | Moetemappe;
  subscribe?: boolean;
}

@route("/lagretSoek")
@tag("LagretSoek")
interface LagretSoekRoutes extends Routable<LagretSoek, "LagretSoek"> {}

/**
 * Tilbakemelding
 */
@extension("x-resourceId", "Tilbakemelding")
@extension("x-idPrefix", "tbm")
model Tilbakemelding extends EInnsynBase {
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

/**
 * Innsynskrav
 */
@extension("x-resourceId", "Innsynskrav")
@extension("x-idPrefix", "ik")
model Innsynskrav extends EInnsynBase {
  @visibility("read") entity?: "Innsynskrav";
  @format("email") email: string;
  innsynskravDel: (EInnsynId | InnsynskravDel)[];
  verified?: boolean;
  bruker?: EInnsynId | Bruker;
  language?: "nb" | "nn" | "en" | "se";
}

@route("/innsynskrav")
@tag("Innsynskrav")
interface InnsynskravRoutes
  extends GloballyRoutable<Innsynskrav, "Innsynskrav"> {
  @route("/{innsynskravId}/innsynskravDel")
  @get
  @operationId("GetInnsynskravDelList")
  getInnsynskravDelList(
    @path innsynskravId: EInnsynId,
  ): ResponseList<InnsynskravDel>;

  @route("/{innsynskravId}/verify/{secret}")
  @put
  @operationId("VerifyInnsynskrav")
  verify(@path innsynskravId: EInnsynId, @path secret: string): Innsynskrav;
}

/**
 * InnsynskravDel
 */
@extension("x-resourceId", "InnsynskravDel")
@extension("x-idPrefix", "ikd")
model InnsynskravDel extends EInnsynBase {
  @visibility("read") entity?: "InnsynskravDel";
  innsynskrav?: EInnsynId | Innsynskrav;
  journalpost: EInnsynId | Journalpost;
  enhet?: EInnsynId | Enhet;
  sent?: utcDateTime;
  retryCount?: integer;
  retryTimestamp?: utcDateTime;
}

@route("/innsynskravDel")
@tag("InnsynskravDel")
interface InnsynskravDelRoutes
  extends Routable<InnsynskravDel, "InnsynskravDel"> {}
